require 'logger'
#require 'active_support' #?
require 'active_support/concern'
require 'active_support/hash_with_indifferent_access'

# explicitly load all files here ...
require "nagyo-worker/version"
require "nagyo-worker/server_helper"
require "nagyo-worker/nventory_sync"

module Nagyo
  module Worker
    extend ActiveSupport::Concern

    #attr_accessor :config
    
    # keep most all these in config yml?
    @config = {
      :sync_nventory_nagyo => false,
      :nventory_host    => "http://nventory.slacklabs.com",

      :nagyo_host       => "http://localhost:3000",
      :nagyo_auth_token => nil,

      :script_base      => "/data/svc/ops/nagyo/nagyo-worker",
      # strings or regex? yaml config would be easier via string
      :npvm_regex       => "npvm.+\.np\..+\.eharmony\.com",
      :npssvm_regex     => "np\..+\.eharmony\.com",
 
      :nagios_dir       => "/etc/nagios/objects",
      :nagios_user      => "root",
      :nagios_group     => "nagios",
      :backup_dir       => "/var/nagyo/backup",

    }

    def self.config
      @config
    end

    # configure from a hash
    def self.configure(opts={})
      @config = @config.merge(opts.to_options)
    end

    # via yaml file
    def self.configure_from_file(filename)
      data = YAML.load_file(filename)
      configure(data)
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    # NOTE: now using nagyo ServerHelper to get hashed data back

    # TODO: deprecate
    def self.get_remote_json(url, file_and_path)
      # uncomment for https
      #url = URI.parse("https://" + url)
      url = URI.parse("http://" + url)
      http = Net::HTTP.new(url.host, url.port)
      # and this for ssl
      #http.use_ssl = true
      resp = http.get(file_and_path)
      return resp.body
    end


    # returns two arrays: graffitis, nodes
    def self.get_data_from_ng(ng)
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


    included do
    end 

    module ClassMethods

      # TODO: can we use actionmailer? 
      def send_email(from, to, subject, message, *cc)
        msg = <<END_OF_MESSAGE
From: #{from}
To: #{to}
CC: #{cc}
Subject: #{subject}

#{message}
END_OF_MESSAGE

        begin
          Net::SMTP.start('localhost') do |smtp|
            smtp.send_message msg, from, to, *cc
          end
        rescue => exception
          puts "RESCUE => MAILER: unable to send mail #{exception}"
          return false
        end
      end

    end # class methods

  end # Worker

end
