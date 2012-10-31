#!/usr/bin/env ruby

# stdlib
require 'erb'
require 'yaml'
require 'rubygems'
require 'tempfile'
require 'digest/md5'
require 'fileutils'
require 'net/smtp'
require 'logger'

require 'json'

# custom libs (moved to Nagyo::Worker::NventorySync )
#require 'nventory'
#require 'nv_helpers'

# our lib
require 'nagyo-worker'

include Nagyo::Worker
logger = Nagyo::Worker.logger
config = Nagyo::Worker.config

logger.info("Starting nagyo-worker ...")

nodes           = {}
node_groups     = {}
service_ngs     = []


# TODO: how to find config file ... in dev? when installed as gem?
# TODO: let set as option on command line
config_file = "nagyo-worker.yml"

# load configuration
if File.exists?(config_file)
  logger.info("Loading nagyo-worker configuration from: #{config_file}") 
  config = Nagyo::Worker.configure_from_file(config_file)
  logger.debug("configuration => #{config.inspect}")
end

#######################



# I'll probably want to move a lot of this to config files
#nventory_host   = "http://nventory.corp.eharmony.com"
#nventory_host   = "http://localhost:7000"
nventory_host   = "http://nventory.slacklabs.com"
#
# nvclient        = NVentory::Client.new(:server => nventory_host, :cookiefile => "/tmp/.nventory-cookie")

#nagyo_host        = "nagios2.np.dc1.eharmony.com:3000"
nagyo_host        = "localhost:3000"
nagyo_auth_token  = 'b4j5qBqzYx5EukCM3Vri'

# 
nagyo_server = Nagyo::Worker::ServerHelper.new
  # :base_url => nagyo_host,
  # :auth_token => nagyo_auth_token)

## move these to nventory sync?
# script_base     = "/data/svc/ops/nagyo/nagyo-worker"
script_base = config[:script_base]


#
reload_required = false



##################



# !! create a temporary directory
tmpdir          = Dir.mktmpdir
logger.debug("Using temporary dir: #{tmpdir}")

# !! create temporary nagios.cfg main file
tmpfile         = Tempfile.new('nagios.cfg').path
logger.debug("Using temporary nagios.cfg := #{tmpfile}")

# !! create tmp directories for new nagios configs
gen_directories = %W(clusters commands contacts hardware hostgroups hosts services)
gen_directories.each {|dir| Dir.mkdir(File.join(tmpdir, dir))} rescue logger.error("Unable to create directories: #{$!}")


# !! create backup directory
FileUtils.mkdir_p(config[:backup_dir])

# pull from nventory and seed nagyo 
# TODO: make optional via cli options
if config[:sync_nventory_nagyo]
  # sync in-service nodes to nagyo hosts
  logger.info("Syncing nventory nodes (#{config[:nventory_host]} to nagyo-server Hosts ...")
  Nagyo::Worker::NventorySync.sync_nventory_nodes(:nventory_host => config[:nventory_host])
end



# helper for writing out config - better as a proc?
def render_erb_tmpfile(context, erb_basename, output_filename)
  Nagyo::Worker.logger.debug("rendering #{erb_basename} to #{output_filename}")
  script_base = Nagyo::Worker.config[:script_base]
  erb_result = ERB.new(File.open("#{script_base}/templates/#{erb_basename}"){ |f| f.read } ).result(context)

  # strip extra whitespace
  erb_result.gsub!(/^$\n/, '')

  f = File.new(output_filename, "wb")
  f.puts erb_result
  f.close

  erb_result
end


# generate nagios config using templates ... in Threads 

# all of the stuff below can be broken out into their own thread
# since they're all doing what amounts to the same thing, but 
# from different sources and to different destinations.


# does this work?

# TODO: do we need nventory nodes here or now re-get from nagyo?
#
# nodes, node_groups = Nagyo::Worker::NventorySync.nventory_nodes
# FIXME: below expects node_groups certain format ... 
#
# another Thread around this call? - or share nodes var?
nodes = hosts = nagyo_server.get_all("hosts")

logger.debug("nodes = #{nodes.inspect}")
# hosts/hosts.cfg (1 file)
#Thread.new do
  # NOTE: the erb template iterates over nodes ...
  render_erb_tmpfile(binding, "hosts.erb", "#{tmpdir}/hosts/hosts.cfg")
#end


# hardware/hardwareID.cfg (1 file per hw profile)
nagyo_server.get_all("hardwareprofiles").each do |hp|
  Thread.new do

    # TODO: what is this for --- hardware_host_list used in erb
    hardware_host_list = []

    # TODO: wha? why does this (over)write the hardware/id.cfg for each hardware-profile check_command??
    hp['check_commands'].each do |cc|
      # FIXME: TODO: uses nventory nodes list here ... but use hosts list from nagyo instead
      nodes.each do |node|
        if node['hardware_profile']['name'] =~ /#{hp['hardware_profile']}/
          hardware_host_list << node['name']
        end
      end

      render_erb_tmpfile("hardware.erb", File.join(tmpdir, "hardware", hp['id'] + '.cfg'))
    end
  end
end

# contacts/contactID.cfg (1 per contact)
nagyo_server.get_all("contacts").each do |cc|
  Thread.new do
    render_erb_tmpfile("contacts.erb", File.join(tmpdir, "contacts", cc['id'] + '.cfg'))
  end
end

# commands/commandID.cfg (1 per command)
nagyo_server.get_all("commands").each do |cc|
##JSON.parse(get_remote_json(nagyo_host, "/commands.json")).each do |cc|
  Thread.new do
    render_erb_tmpfile("commands.erb", File.join(tmpdir, "commands", cc['id'] + '.cfg'))
  end
end

# services are what defines what hostgroups get checks
# this section has a named thread because we'll want to
# do this before we write out all of the hostgroups.
# we do this so we can check for the existence of a check
# which is tied to a hostgroup, so we only write out hostgroups
# that actually have checks tied to them.
#
# 1 thread for all services
services_thread = Thread.new do
  nagyo_server.get_all("services").each do |cc|
    render_erb_tmpfile("services.erb", File.join(tmpdir, "services", cc['id'] + '.cfg'))
    service_ngs << cc['nodegroup']
  end
end

# TODO: service_ngs is used to write out the hostgroup configs, it is updated 
# by above services_thread and by below un-named Clusters thread ... should we 
# just do Hostgroups last after all other threads are finished? 
#
# TODO: also - does services_ngs need to be some Mutex array or is << threadsafe

# put together everything for the Clusters - 1 thread for all clusters
# clusters/clusterID.cfg
clusters_thread = Thread.new do
  nagyo_server.get_all("clusters").each do |cc|
    Thread.new do
      hosts_to_check = []
      cc['nodegroup'].each do |ng|
        # FIXME: which nventory does it use?
        nv_results     = Nagyo::Worker.get_data_from_ng(ng)
        graffitis      = nv_results[0]
        nodes_in_ng    = nv_results[1]
        graffitis['instances'] = 1 if !graffitis.has_key?('instances')
        1.upto(graffitis['instances'].to_i) do |i|
          nodes_in_ng.each do |node|
            hosts_to_check << node + ':' + (graffitis['application_start_port'].to_i + i).to_s
          end
        end

        render_erb_tmpfile("cluster.erb", File.join(tmpdir, "clusters", cc['id'] + '.cfg'))
        service_ngs << cc['nodegroup']
      end
    end
  end
end

# hostgroups and nodegroups are the same thing but named differently
# between nagios and nventory
#
# expecting node_groups like {nodegroup => [hosts], ...}
#
# hostgroups/group_name.cfg for each hostgroup
node_groups.each_pair do |k,v|
  Thread.new do
    services_thread.join
    # TODO: dont we need this too?
    clusters_thread.join

    next if !service_ngs.include?(k)
    render_erb_tmpfile("hostgroups.erb", "#{tmpdir}/hostgroups/#{k}.cfg")
  end
end


sleep 1 until Thread.list.size == 1

exit

# since everything has (presumably) been generated, we can compare
# the files in various ways to see if we need to move and reload.

# create an array for both newly generated files and the existing
# files that are currently being used by nagios.
Dir.chdir(config[:nagios_dir])
old_configs = Dir.glob("**/**").sort
Dir.chdir(tmpdir)
new_configs = Dir.glob("**/**").sort

# if the arrays are different then we know something changed, so
# we can go ahead and reload the configs without comparing the 
# files we've generated.
if old_configs != new_configs
  reload_required = true
else
  new_configs.each do |conf|
    next if File.directory?(File.join(config[:nagios_dir], conf))
    next if File.directory?(File.join(tmpdir, conf))
    if reload_required != true
      new_md5 = Digest::MD5.hexdigest(File.read(File.join(tmpdir, conf)))
      old_md5 = Digest::MD5.hexdigest(File.read(File.join(config[:nagios_dir], conf)))
      if new_md5 != old_md5
        reload_required = true
      end
    end
  end
end

# if we require the configs to be updated let's first run nagios -v 
# against a temporary nagios.cfg file to see if it passes nagios' 
# sanity checks.
if reload_required

  nagios_cfg = ERB.new(File.open("#{script_base}/templates/nagios.cfg.erb"){ |f| f.read }).result(binding)
  f = File.new(tmpfile, "wb")
  f.puts nagios_cfg
  f.close

  # finicky permissions!
  FileUtils.chown_R(config[:nagios_user], config[:nagios_group], tmpdir)
  FileUtils.chmod_R(0655, tmpdir)
  FileUtils.chown(config[:nagios_user], config[:nagios_group], tmpfile)
  FileUtils.chmod(0655, tmpfile)

  if system("/usr/sbin/nagios -v #{tmpfile}") == false
    message = "verification of the nagios configs have failed. please investigate."
    #send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
    exit 1
  else

    # backup old configs
    FileUtils.mv(config[:nagios_dir], File.join(backup_dir, Time.now.to_i.to_s), :force => true)

    # move the configs and restart nagios
    FileUtils.mv(tmpdir, config[:nagios_dir], :force => true)
   
    # restart nagios
    if system("/etc/init.d/nagios reload") == false
      message = "reloading of nagios failed. nagios is down. please investigate immediately."
      #send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
      exit 1
    end
  end
end

