#!/usr/bin/ruby -W0
require 'erb'
require 'rubygems'
require 'nventory'
require 'nv_helpers'
require 'json'
require 'tempfile'
require 'digest/md5'
require 'fileutils'
require 'net/smtp'

# I'll probably want to move a lot of this to config files
nvclient        = NVentory::Client.new(:server => 'http://nventory.corp.eharmony.com', :cookiefile => "/tmp/.nagyocookie")
script_base     = "/data/svc/ops/nagios-automation"
npvm_regex      = "npvm.+\.np\..+\.eharmony\.com"
npssvm_regex    = "np\..+\.eharmony\.com"
nodes           = {}
node_groups     = {}
service_ngs     = []
gen_directories = %W(clusters commands contacts hardware hostgroups hosts services vips)
tmpdir          = Dir.mktmpdir
tmpfile         = Tempfile.new('nagios.cfg').path
nagdir          = "/etc/nagios/objects"
backup_dir      = FileUtils.mkdir_p("/var/nagyo/backup")
reload_required = false
nagios_user     = "root"
nagios_group    = "nagios"
# this should be renamed to something more meaningful:
url             = "nagios2.np.dc1.eharmony.com:3000"
nodes           = nvclient.get_objects(:objecttype => 'nodes',
                                       :get        => {'status[name]' => ['setup', 'inservice', 'ss-inservice']},
                                       :includes   => ['operating_system[name]', 
                                                      'hardware_profile[name]',
                                                      'node_groups',
                                                      'status[name]'],
                                       :format     => 'json')

gen_directories.each {|dir| Dir.mkdir(File.join(tmpdir, dir))}

def get_remote_json(url, file_and_path)
    # uncomment for https
    #url = URI.parse("https://" + url)
    url = URI.parse("http://" + url)
    http = Net::HTTP.new(url.host, url.port)
    # and this for ssl
    #http.use_ssl = true
    resp = http.get(file_and_path)
    return resp.body
end

def get_data_from_ng(ng)
  nv_helper = NvHelpers::NvWrapper.new(:cookiefile => '/tmp/.nagyo-nvcookie')
  # Check that nodegroup exists
  if nv_helper.get_node_group_by_name(ng).nil?
    msg = "Node group #{ng} does not exist in nVentory."
    exit 1
  end
  # These are the graffitis we're interested in
  keys = %w(instances application_start_port)
  graffitis = nv_helper.get_graffitis(ng, keys, true)
  nodes     = nv_helper.get_nodes_from_group(ng).keys
  return graffitis, nodes
end

# note to self: look for something cleaner:
def send_email(from, to, subject, message, *cc)
  msg = <<END_OF_MESSAGE
From: #{from}
To: #{to}
CC: #{cc}
Subject: #{subject}

#{message}
END_OF_MESSAGE
  Net::SMTP.start('localhost') do |smtp|
    smtp.send_message msg, from, to, *cc
  end
  rescue => exception
  puts "RESCUE => MAILER: unable to send mail #{exception}"
  return false
end

# there are a few things we want to check for, the first of
# which being whether or not there is an operating system
# listed for this, the second of which being it's an 
# operating system that we actually care about.
nodes.delete_if {|x| !x.has_key?('operating_system')}
nodes.delete_if {|x| x['operating_system']['name'] !~ /centos|red hat|scientific/i}

# and now let's get rid of all non setup or *inservice nodes
nodes.delete_if {|x| x['status']['name'] !~ /^setup$|inservice$/i}

# here we do various things to the nodes array, there will be a blurb before each of them
nodes.each do |node|
  # we don't really care about alerting on non production hosts (although this may change)
  # so let's just pass the nodes through a regex matching the SSVMs but not the hypervisors
  # and just change their status to 'setup'. jankey?
  if node['name'] !~ /#{npvm_regex}/ && node['name'] =~ /#{npssvm_regex}/
    node['status']['name'] = 'setup'
  end
  # this isn't all that necessary:
  if node['status']['name'] =~ /inservice/
    node['status']['name'] = 'inservice'
  end
  # let's put all of the nodegroups into a new array which just lists the names and the nodes belonging to them
  node['node_groups'].each do |ng|
    node_groups[ng['name']] = [] if !node_groups.has_key?(ng['name'])
    node_groups[ng['name']] << node['name']
  end
end

# all of the stuff below can be broken out into their own thread
# since they're all doing what amounts to the same thing, but 
# from different sources and to different destinations.
# hosts/hosts.cfg
Thread.new do
  hosts = ERB.new(File.open(File.join(script_base, "templates/hosts.erb")){ |f| f.read } ).result(binding)
  f = File.new(File.join(tmpdir, "hosts/hosts.cfg"), "wb")
  f.puts hosts
  f.close
end

# hardware/hardware.cfg
JSON.parse(get_remote_json(url, "/hardwareprofiles.json")).each do |hp|
  Thread.new do
    hardware_host_list = []
    hp['check_commands'].each do |cc|
      nodes.each do |node|
        if node['hardware_profile']['name'] =~ /#{hp['hardware_profile']}/
          hardware_host_list << node['name']
        end
      end
      hardware = ERB.new(File.open(File.join(script_base, "templates/hardware.erb")){ |f| f.read }).result(binding)
      f = File.new(File.join(tmpdir, "hardware", hp['id'] + ".cfg"), "wb")
      f.puts hardware
      f.close
    end
  end
end

# contacts/contacts.cfg
JSON.parse(get_remote_json(url, "/contacts.json")).each do |cc|
  Thread.new do
    contact = ERB.new(File.open(File.join(script_base, "templates/contacts.erb")){ |f| f.read }).result(binding)
    f = File.new(File.join(tmpdir, "contacts", cc['id'] + ".cfg"), "wb")
    f.puts contact
    f.close
  end
end

# commands/commands.cfg
JSON.parse(get_remote_json(url, "/commands.json")).each do |cc|
  Thread.new do
    command = ERB.new(File.open(File.join(script_base, "templates/commands.erb")){ |f| f.read }).result(binding)
    f       = File.new(File.join(tmpdir, "commands", cc['id'] + ".cfg"), "wb")
    f.puts command
    f.close
  end
end

# services are what defines what hostgroups get checks
# this section has a named thread because we'll want to
# do this before we write out all of the hostgroups.
# we do this so we can check for the existence of a check
# which is tied to a hostgroup, so we only write out hostgroups
# that actually have checks tied to them.
services_thread = Thread.new do
  JSON.parse(get_remote_json(url, "/services.json")).each do |cc|
    config = ERB.new(File.open(File.join(script_base, "templates/services.erb")){ |f| f.read }).result(binding)
    f = File.new(File.join(tmpdir, "services", cc['id'] + ".cfg"), "wb")
    f.puts config
    f.close
    service_ngs << cc['_nodegroup']
  end
end

# put together everything for the VIPs
Thread.new do
  JSON.parse(get_remote_json(url, "/vips.json")).each do |cc|
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
        vip = ERB.new(File.open(File.join(script_base, "templates/vip.erb")){ |f| f.read }).result(binding)
        f = File.new(File.join(tmpdir, "vips", cc['id'] + ".cfg"), "wb")
        f.puts vip
        f.close
        service_ngs << cc['nodegroup']
      end
    end
  end
end

# put together everything for the Clusters
Thread.new do
  JSON.parse(get_remote_json(url, "/clusters.json")).each do |cc|
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
        cluster = ERB.new(File.open(File.join(script_base, "templates/cluster.erb")){ |f| f.read }).result(binding)
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
node_groups.each_pair do |k,v|
  Thread.new do
    services_thread.join
    next if !service_ngs.include?(k)
    hostgroups = ERB.new(File.open(File.join(script_base, "templates/hostgroups.erb")){ |f| f.read }).result(binding)
    f = File.new(File.join(tmpdir, "hostgroups", k + ".cfg"), "wb")
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

  nagios_cfg = ERB.new(File.open(File.join(script_base, "templates/nagios.cfg.erb")){ |f| f.read }).result(binding)
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
    send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
    exit 1
  else

    # backup old configs
    FileUtils.mv(nagdir, File.join(backup_dir, Time.now.to_i.to_s), :force => true)

    # move the configs and restart nagios
    FileUtils.mv(tmpdir, nagdir, :force => true)

    # restart nagios
    if system("/etc/init.d/nagios reload") == false
      message = "reloading of nagios failed. nagios is down. please investigate immediately."
      send_email("pobrien@eharmony.com", "pobrien@eharmony.com", "nagios config generation failed", message)
      exit 1
    end
  end
end

