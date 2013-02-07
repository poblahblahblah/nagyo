#!/usr/bin/env ruby


#
# Nagyo Worker
#
#
# Options that can be set via option file (some via command line):
#   See also lib/nagyo_worker.rb for defaults
#
#   - nagyo_worker_config
#
#   - nagios_tmpdir
#   - nagios_dir
#   - backup_dir
#   - script_base
#
#   - sync_nventory_nagyo  (bool)
#   - nventory_host
#   - nagyo_host
#   - nagyo_auth_token



require 'rubygems'

# stdlib
require 'optparse'
require 'erb'
require 'yaml'
require 'tempfile'
require 'digest/md5'
require 'fileutils'
require 'net/smtp'
require 'logger'

# our lib(s)
require 'nagyo-worker'
require 'nagyo-server-helper'

include Nagyo::Worker
logger = Nagyo::Worker.logger
logger.level = Logger::WARN

config = Nagyo::Worker.config

nodes           = {}
service_ngs     = []


opts = OptionParser.new do |opts|
  opts.banner = "Usage: #$0 [options]"

  opts.on('-c', '--config FILE', 'load nagyo-worker config from FILE (after options)') do |file|
    config[:nagyo_worker_config] = file
  end

  opts.on('-s', '--[no-]sync', "Whether to sync nVentory nodes to Nagyo Hosts (default #{config[:sync_nventory_nagyo]})") do |sync|
    config[:sync_nventory_nagyo] = !! sync
  end
  opts.on('--nagyo-host HOST', "The nagyo HOST to contact (default #{config[:nagyo_host]})") do |host|
    config[:nagyo_host] = host
  end
  opts.on('--nagyo-auth TOKEN', "The nagyo TOKEN to authorize creation of new records") do |token|
    config[:nagyo_auth_token] = token
  end

  opts.on('--nventory-host HOST', "The nVentory HOST to contact (default #{config[:nventory_host]})") do |host|
    config[:nventory_host] = host
  end

  opts.on('--script-base DIR', "The script base DIR where nagyo-worker installed (default #{config[:script_base]})") do |dir|
    config[:script_base] = dir
  end
  opts.on('--nagios-dir DIR', "The DIR where nagios config lives (default #{config[:nagios_dir]})") do |dir|
    config[:nagios_dir] = dir
  end
  opts.on('--backup-dir DIR', "The DIR where nagios configs are backed up during overwrite (default #{config[:backup_dir]})") do |dir|
    config[:backup_dir] = dir
  end
  opts.on('--nagios-tmpdir DIR', "The temporary DIR where nagios config is written (default :auto)") do |dir|
    config[:nagios_tmpdir] = dir
  end

  # logger output to file?
  # log level? off / --verbose / --debug
  opts.on('-v', '--[no-]verbose', "Whether to log script output") do |v|
    config[:verbose] = !! v
    if config[:verbose]
      logger.level = Logger::INFO
    end
  end
  opts.on('-d', '--[no-]debug', "Whether to log debug output also") do |d|
    config[:debug] = !! d
    if config[:debug]
      config[:verbose] = config[:debug]
      logger.level = Logger::DEBUG
    end
  end
end

opts.parse!(ARGV)


################################################################################
#  Nagyo Worker script __MAIN__
################################################################################
#
# - load config file
# - maybe sync nventory nodes -> nagyo
# - generate nagios configs
# - check if valid and if changed -> replace existing

logger.info("Starting nagyo-worker ...")

# TODO: search a few places for nagyo-worker.yml ...
# does nagyo config have '/' ? else search a few paths
config_file = config[:nagyo_worker_config] || "nagyo-worker.yml"
config_paths = [config[:script_base], config[:nagios_dir], config[:backup_dir]]

# load configuration from yml file -- but occurs after options are parsed ...
if File.exists?(config_file)
  logger.info("Loading nagyo-worker configuration from: #{config_file}") 
  config = Nagyo::Worker.configure_from_file(config_file)
  logger.debug("configuration => #{config.inspect}")
end

# done setting / resetting configuration options
#######################


#######################
# build up nagyo server client
# uses Nagyo::Worker.config internally
nagyo_server = Nagyo::Server::Helper.new(config[:nagyo_host], config[:nagyo_auth_token])

script_base = config[:script_base]


#
reload_required = false


  # Create directory that will be used for nagios config
  FileUtils.mkdir_p(config[:nagios_dir])

  # create backup directory
  FileUtils.mkdir_p(config[:backup_dir])

  # create a temporary directory for staging generated output
  config[:nagios_tmpdir] ||= Dir.mktmpdir("nagyo-worker")
  FileUtils.mkdir_p(config[:nagios_tmpdir])
  logger.debug("Using temporary dir: #{config[:nagios_tmpdir]}")

  # !! create temporary nagios.cfg main file
  tmp_nagios_cfg = Tempfile.new(['nagios','.cfg'], config[:nagios_tmpdir]).path
  logger.debug("Using temporary nagios.cfg := #{tmp_nagios_cfg}")

  # !! create tmp directories for new nagios configs
  gen_directories = config[:nagios_object_dirs] #
  gen_directories.each {|dir| Dir.mkdir(File.join(config[:nagios_tmpdir], dir))} rescue logger.error("Unable to create directories: #{$!}")




##################

## pull nodes from nventory and sync to nagyo

#config[:sync_nventory_nagyo] = true
if config[:sync_nventory_nagyo]
  # sync in-service nodes to nagyo hosts
  logger.info("Syncing nventory nodes (#{config[:nventory_host]} to nagyo-server Hosts ...")
  Nagyo::Worker::NventorySync.sync_nventory_nodes_to_nagyo(:nventory_host => config[:nventory_host])
end


##################


# helper for writing out Nagios config using ERB templates
def render_erb_tmpfile(context, erb_basename, output_filename)
  Nagyo::Worker.logger.debug("rendering #{erb_basename} to #{output_filename}")
  script_base = Nagyo::Worker.config[:script_base]
  tmpdir = Nagyo::Worker.config[:nagios_tmpdir]

  # output file into tmpdir
  output_filename = File.join(tmpdir, output_filename) unless output_filename.match(%r{^/})

  # render template to string
  erb_result = ERB.new(File.open("#{script_base}/templates/#{erb_basename}"){ |f| f.read } ).result(context)

  # strip extra whitespace
  erb_result.gsub!(/^$\n/, '')

  f = File.new(output_filename, "ab")  # append, binary
  f.puts erb_result
  f.close

  erb_result
end

##################


# generate nagios config using templates ... in Threads 

# all of the stuff below can be broken out into their own thread
# since they're all doing what amounts to the same thing, but 
# from different sources and to different destinations.


#
config_writer_threads = []

all_hosts = []

# hosts/hosts.cfg (1 file)
hosts_thread = Thread.new do

  page = 1
  hosts = nagyo_server.get("hosts") # first page
  while ! hosts.empty?
    all_hosts += hosts

    # render these hosts
    render_erb_tmpfile(binding, "hosts.erb", "hosts/hosts.cfg")

    page += 1
    hosts = nagyo_server.get("hosts", nil, :params => {:page => page})
  end

end
config_writer_threads << hosts_thread

# NOTE: the below uses all_hosts var - which is filled by hosts_thread above

# hardware/hardwareID.cfg (1 file per hw profile)
nagyo_server.get_all("hardwareprofiles").each do |hp|
  config_writer_threads << Thread.new do
    hosts_thread.join # need all_hosts

    # TODO: what is this for --- hardware_host_list used in erb
    hardware_host_list = []

    all_hosts.each do |host|
      if host['hardware_profile'] =~ /#{hp['hardware_profile']}/
        hardware_host_list << host['host_name']
      end
    end

    hp['check_commands'].to_a.each do |cc|
      # write the hardware/id.cfg for each hardware-profile check_command?
      render_erb_tmpfile(binding, "hardware.erb", File.join("hardware", hp['_id'] + '.cfg'))
    end
  end
end

# contacts/contactID.cfg (1 per contact)
nagyo_server.get_all("contacts").each do |cc|
  config_writer_threads << Thread.new do
    render_erb_tmpfile(binding, "contacts.erb", File.join("contacts", cc['_id'] + '.cfg'))
  end
end

# commands/commandID.cfg (1 per command)
nagyo_server.get_all("commands").each do |cc|
  config_writer_threads << Thread.new do
    render_erb_tmpfile(binding, "commands.erb", File.join("commands", cc['_id'] + '.cfg'))
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
    render_erb_tmpfile(binding, "services.erb", File.join("services", cc['_id'] + '.cfg'))
    service_ngs << cc['hostgroup']
  end
end
config_writer_threads << services_thread

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
      # only one hostgroup - why do each here??
      cc['hostgroup'].each do |ng|
        # FIXME: which nventory does it use?
        nv_results     = Nagyo::Worker::NventorySync.get_data_from_ng(ng)
        graffitis      = nv_results[0]
        nodes_in_ng    = nv_results[1]
        graffitis['instances'] = 1 if !graffitis.has_key?('instances')
        1.upto(graffitis['instances'].to_i) do |i|
          nodes_in_ng.each do |node|
            hosts_to_check << node + ':' + (graffitis['application_start_port'].to_i + i).to_s
          end
        end

        render_erb_tmpfile(binding, "cluster.erb", File.join("clusters", cc['_id'] + '.cfg'))
        service_ngs << cc['hostgroup']
      end
    end
  end
end
config_writer_threads << clusters_thread

# hostgroups and nodegroups are the same thing but named differently
# between nagios and nventory
#
# hostgroups/group_name.cfg for each hostgroup
nagyo_server.get_all("hostgroups").each do |hg|
  config_writer_threads << Thread.new do
    services_thread.join
    # TODO: dont we need this too?
    clusters_thread.join

    # NOTE: only outputting hostgroups attached to cluster or service
    next if !service_ngs.include?(hg["hostgroup_name"])
    render_erb_tmpfile(binding, "hostgroups.erb", "hostgroups/#{hg['_id']}.cfg")
  end
end


logger.debug("Waiting for threads now: #{config_writer_threads}")
#config_writer_threads.map(&:join)

config_writer_threads.each do |t|
  begin
    t.join
  rescue Exception => e
    logger.error("exception in joining thread #{t}: #{$!}")
    #logger.error(%Q{#{e.inspect} ... #{e.backtrace.join("\n")}})
  end
end




sleep 1 until Thread.list.size == 1



# since everything has (presumably) been generated, we can compare
# the files in various ways to see if we need to move and reload.

logger.debug("Comparing nagios configurations ...")
# create an array for both newly generated files and the existing
# files that are currently being used by nagios.
Dir.chdir(config[:nagios_dir])
old_configs = Dir.glob("**/**").sort
Dir.chdir(config[:nagios_tmpdir])
new_configs = Dir.glob("**/**").sort

# if the arrays are different then we know something changed, so
# we can go ahead and reload the configs without comparing the 
# files we've generated.
if old_configs != new_configs
  reload_required = true
else
  new_configs.each do |conf|
    next if File.directory?(File.join(config[:nagios_dir], conf))
    next if File.directory?(File.join(config[:nagios_tmpdir], conf))
    if reload_required != true
      new_md5 = Digest::MD5.hexdigest(File.read(File.join(config[:nagios_tmpdir], conf)))
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
  logger.debug("Reload of nagios required will be require.  Checking generated configs ...")

  render_erb_tmpfile(binding, "nagios.cfg.erb", tmp_nagios_cfg)

  # finicky permissions!
  begin
    FileUtils.chown_R(config[:nagios_user], config[:nagios_group], config[:nagios_tmpdir])
    FileUtils.chmod_R(0655, config[:nagios_tmpdir])
    FileUtils.chown(config[:nagios_user], config[:nagios_group], tmp_nagios_cfg)
    FileUtils.chmod(0655, tmp_nagios_cfg)
  rescue Exception => e
    logger.error("ERROR: unable to change permissions of nagios configs, Nagios will complain ... #{e}")
  end

  logger.info("Attempting verification of nagios configs ...")

  check_nagios_cmd = "/usr/sbin/nagios -v #{tmp_nagios_cfg}"
  logger.debug("Running nagios check: #{check_nagios_cmd}")
  if system(check_nagios_cmd) == false
    message = "** ERROR: verification of the nagios configs have failed. please investigate."
    logger.error(message)
    #send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
    exit 1

  else

    logger.info("Backing up existing nagios configs from #{config[:nagios_dir]} ...")
    FileUtils.mv(config[:nagios_dir], File.join(config[:backup_dir], Time.now.to_i.to_s), :force => true, :verbose => config[:verbose])

    logger.info("Moving generated nagios configs into #{config[:nagios_dir]} ...")
    FileUtils.mv(config[:nagios_tmpdir], config[:nagios_dir], :force => true, :verbose => config[:verbose])

    # restart nagios
    reload_nagios_cmd = "/etc/init.d/nagios reload"
    logger.info("Restarting nagios via: #{reload_nagios_cmd} ...")
    if system(reload_nagios_cmd) == false
      message = "*** ERROR: reloading of nagios failed. nagios is down. please investigate immediately."
      logger.error(message)
      #send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
      exit 1
    end
  end
end

