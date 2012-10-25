require 'logger'
require 'active_support'

# explicitly load all files here ...
require "nagyo-worker/version"
require "nagyo-worker/server_helper"
require "nagyo-worker/nventory_sync"

module Nagyo
  module Worker
    extend ActiveSupport::Concern

    # TODO: find better way to do this ... and whether the other methods are 
    # class or module methods ... ActiveSupport::Concern?
    #
    #attr_accessor :logger
    included do
      def logger
        @logger ||= Logger.new(STDOUT)
      end

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

    end # included


  end # Worker

end
