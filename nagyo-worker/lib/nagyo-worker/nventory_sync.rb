
# Sync nodes from nVentory to Nagyo hosts.

# other libs
require 'nventory'
require 'nv_helpers'

module Nagyo::Worker
  # class?
  module NventorySync
    #include Nagyo::Worker


    # TODO: rely on nventory config ...  can we have conf file in distribution?  
    # gemfile config file resource?


    # pulls nodes and nodegroups from nventory server and returns the result.
    #
    # Returns: [nodes, nodegroups]
    #   nodes: { "host_name" => {...}, ... }
    #   nodegroups: { "node_group" => [host1, host2, ...], ... }
    #
    def self.nventory_nodes_and_groups(opts = {})

      # TODO: use a Config for this?
      # I'll probably want to move a lot of this to config files
      #nventory_host   = "http://nventory.corp.eharmony.com"
      #nventory_host   = "http://localhost:7000"
      #
      nventory_host   = opts[:nventory_host] || "http://nventory.slacklabs.com"
      nvclient        = NVentory::Client.new(:server => nventory_host, :cookiefile => "/tmp/.nventory-cookie")
      nodes           = {}
      node_groups     = {}
      service_ngs     = []

      # this returns a hash host_name => {host_data}
      # TODO: this could also be specified in config .. e.g. yaml
      nodes           = nvclient.get_objects(:objecttype => 'nodes',
                                             :get        => {'status[name]' => ['setup', 'inservice', 'ss-inservice']},
                                             :includes   => ['operating_system[name]', 
                                               'hardware_profile[name]',
                                               'node_groups',
                                               'status[name]'],
                                             :format     => 'json')

      #Nagyo::Worker.logger.debug("Got nodes from nventory (#{nventory_host}): 
      ##{nodes.inspect}")

      script_base     = "/data/svc/ops/nagyo/nagyo-worker"
      npvm_regex      = "npvm.+\.np\..+\.eharmony\.com"
      npssvm_regex    = "np\..+\.eharmony\.com"
      # there are a few things we want to check for, the first of
      # which being whether or not there is an operating system
      # listed for this, the second of which being it's an 
      # operating system that we actually care about.
      nodes.delete_if { |x,y| ! y.has_key?('operating_system') }

      nodes.delete_if { |x,y| y['operating_system']['name'] !~ /centos|red hat|scientific/i }

      # and now let's get rid of all non setup or *inservice nodes
      nodes.delete_if { |x,y| y['status']['name'] !~ /^setup$|inservice$/i }

      # here we do various things to the nodes array, there will be a blurb before each of them
      nodes.each do |node_name, node|
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


      return [nodes, node_groups]
    end # nventory_nodes


    # load nventory nodes into nagyo-server.
    #
    # Will create/update nagyo models for Host, Hostgroup, Hardwareprofile
    #
    # Data to preserve:
    #   Node.name => Host.host_name
    #   Node.node_groups => []  => Host.node_groups Nodegroup.new ...
    #   Node.hardware_profile => {:name => ""}
    #   Node.status => {:name => "", :description => ""} ?
    #
    def self.sync_nventory_nodes(opts = {})
      #
      nodes, nodegroups = nventory_nodes_and_groups

      logger.debug("Got nodes from nventory (#{opts[:nventory_host]}): #{nodes.keys.inspect}")
      logger.debug("Got node groups from nventory #{nodegroups.keys.inspect}")

      # first make nodegroups
      nodegroups.each do |n|
      end


      # then make hosts, creating other models as needed:
      #   - Hardwareprofile


    end

  end

end
