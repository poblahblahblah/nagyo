#!/usr/bin/env ruby

# stdlib
require 'erb'
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

logger.debug("Starting nagyo-worker ...")

nodes           = {}
node_groups     = {}
service_ngs     = []

# I'll probably want to move a lot of this to config files
#nventory_host   = "http://nventory.corp.eharmony.com"
#nventory_host   = "http://localhost:7000"
nventory_host   = "http://nventory.slacklabs.com"

#nagyo_host             = "nagios2.np.dc1.eharmony.com:3000"
nagyo_host             = "localhost:3000"

# nvclient        = NVentory::Client.new(:server => nventory_host, :cookiefile => "/tmp/.nventory-cookie")

# move these to nventory sync?
script_base     = "/data/svc/ops/nagyo/nagyo-worker"
npvm_regex      = "npvm.+\.np\..+\.eharmony\.com"
npssvm_regex    = "np\..+\.eharmony\.com"

nagdir          = "/etc/nagios/objects"
reload_required = false
nagios_user     = "root"
nagios_group    = "nagios"

gen_directories = %W(clusters commands contacts hardware hostgroups hosts services vips)


# !!
tmpdir          = Dir.mktmpdir
# !! create temporary nagios.cfg main file
tmpfile         = Tempfile.new('nagios.cfg').path

# !! create backup directory
backup_dir      = FileUtils.mkdir_p("/var/nagyo/backup")

# !! create tmp directories for new nagios configs
gen_directories.each {|dir| Dir.mkdir(File.join(tmpdir, dir))} rescue logger.error("Unable to create directories: #{$!}")


# pull from nventory and seed nagyo
Nagyo::Worker::NventorySync.sync_nventory_nodes(:nventory_host => nventory_host)

# TODO: do we need nventory nodes here or now re-get from nagyo?

#nodes, node_groups = Nagyo::Worker::NventorySync.nventory_nodes




# generate nagios config using templates

# all of the stuff below can be broken out into their own thread
# since they're all doing what amounts to the same thing, but 
# from different sources and to different destinations.


# - hosts.cfg
# - hardware.cfg
# - 

# hosts/hosts.cfg
Thread.new do
  # NOTE: the erb template iterates over nodes ...
  hosts = ERB.new(File.open("#{script_base}/templates/hosts.erb"){ |f| f.read } ).result(binding)
  f = File.new("#{tmpdir}/hosts/hosts.cfg", "wb")
  f.puts hosts
  f.close
end

# hardware/hardwareID.cfg
JSON.parse(get_remote_json(nagyo_host, "/hardwareprofiles.json")).each do |hp|
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

      hardware = ERB.new(File.open("#{script_base}/templates/hardware.erb") {|f| f.read }).result(binding)
      f = File.new(File.join(tmpdir, "hardware", hp['id'] + ".cfg"), "wb")
      f.puts hardware
      f.close
    end
  end
end

# contacts/contactID.cfg
JSON.parse(get_remote_json(nagyo_host, "/contacts.json")).each do |cc|
  Thread.new do
    contact = ERB.new(File.open("#{script_base}/templates/contacts.erb") {|f| f.read }).result(binding)
    f = File.new(File.join(tmpdir, "contacts", cc['id'] + ".cfg"), "wb")
    f.puts contact.gsub(/^$\n/, '')
    f.close
  end
end

# commands/commandID.cfg
JSON.parse(get_remote_json(nagyo_host, "/commands.json")).each do |cc|
  Thread.new do
    command = ERB.new(File.open("#{script_base}/templates/commands.erb") {|f| f.read }).result(binding)
    f       = File.new(File.join(tmpdir, "commands", cc['id'] + ".cfg"), "wb")
    f.puts command.gsub(/^$\n/, '')
    f.close
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
  JSON.parse(get_remote_json(nagyo_host, "/services.json")).each do |cc|
    config = ERB.new(File.open("#{script_base}/templates/services.erb"){ |f| f.read }).result(binding)
    f = File.new(File.join(tmpdir, "services", cc['id'] + ".cfg"), "wb")
    f.puts config.gsub(/^$\n/, '')
    f.close
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
  JSON.parse(get_remote_json(nagyo_host, "/clusters.json")).each do |cc|
    Thread.new do
      hosts_to_check = []
      cc['nodegroup'].each do |ng|
        nv_results     = get_data_from_ng(ng)
        graffitis      = nv_results[0]
        nodes_in_ng    = nv_results[1]
        graffitis['instances'] = 1 if !graffitis.has_key?('instances')
        1.upto(graffitis['instances'].to_i) do |i|
          nodes_in_ng.each do |node|
            hosts_to_check << node + ':' + (graffitis['application_start_port'].to_i + i).to_s
          end
        end
        cluster = ERB.new(File.open("#{script_base}/templates/cluster.erb"){ |f| f.read }).result(binding)
        f = File.new(File.join(tmpdir, "clusters", cc['id'] + ".cfg"), "wb")
        f.puts cluster
        f.close
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

    hostgroups = ERB.new(File.open("#{script_base}/templates/hostgroups.erb"){ |f| f.read }).result(binding)
    f = File.new("#{tmpdir}/hostgroups/#{k}.cfg", "wb")
    f.puts hostgroups
    f.close
  end
end


sleep 1 until Thread.list.size == 1

# since everything has (presumably) been generated, we can compare
# the files in various ways to see if we need to move and reload.

# create an array for both newly generated files and the existing
# files that are currently being used by nagios.
Dir.chdir(nagdir)
old_configs = Dir.glob("**/**").sort
Dir.chdir(tmpdir)
new_configs = Dir.glob("**/**").sort

# if the arrays are different then we know something changed, so
# we can go ahead and reload the configs without comparing the 
# files we've generated.
if old_configs != new_configs
  reload_required = true
else
  new_configs.each do |config|
    next if File.directory?(File.join(nagdir, config))
    next if File.directory?(File.join(tmpdir, config))
    if reload_required != true
      new_md5 = Digest::MD5.hexdigest(File.read(File.join(tmpdir, config)))
      old_md5 = Digest::MD5.hexdigest(File.read(File.join(nagdir, config)))
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
  FileUtils.chown_R(nagios_user, nagios_group, tmpdir)
  FileUtils.chmod_R(0655, tmpdir)
  FileUtils.chown(nagios_user, nagios_group, tmpfile)
  FileUtils.chmod(0655, tmpfile)

  if system("/usr/sbin/nagios -v #{tmpfile}") == false
    message = "verification of the nagios configs have failed. please investigate."
    #send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
    exit 1
  else

    # backup old configs
    FileUtils.mv(nagdir, File.join(backup_dir, Time.now.to_i.to_s), :force => true)

    # move the configs and restart nagios
    FileUtils.mv(tmpdir, nagdir, :force => true)
   
    # restart nagios
    if system("/etc/init.d/nagios reload") == false
      message = "reloading of nagios failed. nagios is down. please investigate immediately."
      #send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
      exit 1
    end
  end
end

