
# Sync nodes from nVentory to Nagyo hosts.

# external libs
require 'nventory'
require 'nv_helpers'
require 'nagyo-server-helper'

module Nagyo::Worker
  # class?
  module NventorySync
    def self.config
      Nagyo::Worker.config
    end

    def self.logger
      Nagyo::Worker.logger
    end

    # returns two arrays: graffitis, nodes
    # NvWrapper uses an NVentory::Client
    def self.get_data_from_ng(ng)
      nv_helper = NvHelpers::NvWrapper.new(:server => config[:nventory_host],
                                           :cookiefile => config[:cookiefile])

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

    # pulls nodes and nodegroups from nventory server and returns the result as 
    # an array of two elements: nodes, nodegroups.
    #
    # Returns: [nodes, nodegroups]
    #   nodes: { "host_name" => {...}, ... }
    #   nodegroups: { "node_group" => [host1, host2, ...], ... }
    #
    def self.nventory_nodes_and_groups(opts = {})

      Nagyo::Worker.configure(opts)

      nventory_host   = opts[:nventory_host] || config[:nventory_host]
      nvclient        = NVentory::Client.new(:server => nventory_host,
                                             :cookiefile => config[:cookiefile])
      nodes           = {}
      node_groups     = {}

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

      # TODO: do we still want to filter out all not-inservice nodes here?
      # what if a host is inservice, gets put in nagyo, then later out of 
      # service - how to pull out of nagyo and avoid monitoring?

      # there are a few things we want to check for, the first of
      # which being whether or not there is an operating system
      # listed for this, the second of which being it's an 
      # operating system that we actually care about.
      nodes.delete_if { |x,y| ! y.has_key?('operating_system') }

      nodes.delete_if { |x,y| y['operating_system']['name'] !~ /centos|red hat|scientific/i }

      # and now let's get rid of all *NON* setup or inservice nodes, leaving 
      # only setup and /.*inservice/ - maybe not needed since we :get only 
      # three status types when selecting above.
      nodes.delete_if { |x,y| y['status']['name'] !~ /^setup$|inservice$/i }

      # here we do various things to the nodes array, there will be a blurb before each of them
      nodes.each do |node_name, node|
        # we don't really care about alerting on non production hosts (although this may change)
        # so let's just pass the nodes through a regex matching the SSVMs but not the hypervisors
        # and just change their status to 'setup'. jankey?
        if node['name'] !~ /#{config[:npvm_regex]}/ && node['name'] =~ /#{config[:npssvm_regex]}/
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
    end # nventory_nodes_and_groups


    # load nventory nodes into nagyo-server.
    # nVentory is authoritative for Node information, status.  Nagyo just 
    # stores a partial representation of Node data.
    #
    # Will create/update nagyo models for Host, Hostgroup, Hardwareprofile
    #
    # Data to preserve:
    #   Node.name => Host.host_name
    #   Node.node_groups => []  => Host.node_groups Nodegroup.new ...
    #   Node.hardware_profile => {:name => ""}
    #
    # Data transformed: (Nagyo Host does not have :status field)
    #   - Node.status => {:name => "", :description => ""}
    #     - node.status determines the notification options for Nagyo host
    #
    # TODO: keep track of nodes that exist in nagyo that are not synced anymore -- need to delete
    # TODO: make this faster by batching or limiting data pulls of e.g. all hosts at once
    #
    #
    def self.sync_nventory_nodes_to_nagyo(opts = {})
      #
      Nagyo::Worker.configure(opts)

      nodes, nodegroups = nventory_nodes_and_groups

      nagyo = Nagyo::Server::Helper.new(config[:nagyo_host], config[:nagyo_auth_token])

      nagyo.raise_errors = false

      logger.debug("Got nodes from nventory (#{config[:nventory_host]}): #{nodes.keys.inspect}")
      logger.debug("Got node groups from nventory #{nodegroups.inspect}")

      # debug output of nventory nodes to Yaml
      if config[:dump_nodes]
        outf = File.new("nventory-nodes-#{Time.now.to_i}.yml", "wb")
        outf.puts YAML.dump({:nodes => nodes, :nodegroups => nodegroups})
        outf.close
      end

      ### nodegroups => hostgroups
      #
      logger.info("Making Nagyo hostgroups for nVentory nodegroups ...")
      nagyo_hostgroups = nagyo.get_all("hostgroups").group_by {|x| x["hostgroup_name"] }

      nodegroups.each do |group, members|
        members = members.flatten
        if nagyo_hostgroups.include?(group)
          # update existing ...
          nagyo.update("hostgroup", group, :members => members)
        else
          # make hostgroup in nagyo
          nagyo.create("hostgroup", :hostgroup_name => group, :members => members)
        end
      end


      ### nodes => hosts
      #
      logger.info("Making Nagyo Hosts for nVentory nodes ...")
      # TODO: get hosts from nagyo-server - so we know what hosts are not in 
      # the nVentory inservice node list
      #
      # TODO: make each Host in nagyo - though, Host requires many other fields 
      # to construct :\  Required and not otherwise defaulted:
      #   - :host_name, :address, :contacts
      #   - what should :contacts be?
      nagyo_hosts = nagyo.get_all("hosts").group_by {|x| x["host_name"] }
      # returns hash of { hwprofile => [{profile => data}], ...}
      nagyo_hwprofiles = nagyo.get_all("hardwareprofile").group_by {|x| x["hardware_profile"] }

      nodes.each do |host_name, node|

        # check for hardware profile:?
        # TODO: but nagyo Host has no hardwareprofile ... should it?
        hwprofile = node["hardware_profile"]["name"]
        if hwprofile && !nagyo_hwprofiles.keys.include?(hwprofile)
          logger.info("Creating Nagyo Hardwareprofile for #{hwprofile}.")
          nagyo.create("hardwareprofile", :hardware_profile => hwprofile)
          nagyo_hwprofiles[hwprofile] = "created"
        end

        host_options = {
          :host_name   => node["name"],
          :hardware_profile_id => hwprofile,
        }

        status = node["status"]["name"]
        # NOTE: this used to be in erb template for nagios Host output
        if status.match(/inservice/)
          host_options.merge!({
            :notifications_enabled  => 1,
            :notification_interval  => 5,
            :notification_period_id => '24x7',
          })
        elsif status.match(/setup/)
          host_options.merge!({
            :notifications_enabled  => 0,
            :notification_interval  => 120,
            :notification_period_id => 'workhours',
          })
        end

        if node["nodegroups"]
          host_options[:hostgroups] = (node["nodegroups"].collect(&:name) rescue [])
        end

        result = nil
        if nagyo_hosts.include?(host_name)
          logger.debug("update existing host #{host_name}")
          # what would we update ... only update status ... ?
          h = nagyo_hosts[host_name].first
          #logger.debug("updating host #{host_name}: #{h.inspect}")
          result = nagyo.update("host", h["_id"], host_options)
        else
          # create new
          # massage nventory Node data into Nagyo Host data
          logger.debug("creating new host #{host_name}")
          # TODO: check for default_contact in nagyo ... otherwise creation 
          # will fail with 406 NotAcceptable

          new_opts = host_options.merge({
            # for now we need to set some required fields:
            :address     => host_name,
            :contact_ids => [ config[:default_contact] ],
            :check_command_id => "check_tcp",
          })

          result = nagyo.create("host", new_opts)
          # check if result is success?
          nagyo_hosts[host_name] = "created"
        end
        logger.debug("host update/new result = #{result}")

      end


      return nodes, nodegroups
    end

  end

end
