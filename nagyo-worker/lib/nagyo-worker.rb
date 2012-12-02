require 'logger'
#require 'active_support' #?
#require 'active_support/concern'
require 'active_support/hash_with_indifferent_access'

# explicitly load all files here ...
require "nagyo-worker/version"
require "nagyo-worker/nventory_sync"

module Nagyo
  module Worker
    #attr_accessor :config
    #
    # keep most all these in config yml?
    @config = HashWithIndifferentAccess.new({
      :sync_nventory_nagyo => false,
      :nventory_host    => "http://nventory.slacklabs.com",
      :cookiefile       => "/tmp/nagyo-worker-nventory.cookie",

      :script_base      => "/data/svc/ops/nagyo/nagyo-worker",
      :npvm_regex       => "npvm.+\.np\..+\.eharmony\.com",
      :npssvm_regex     => "np\..+\.eharmony\.com",

      :nagios_dir       => "/etc/nagios/objects",
      :nagios_user      => "root",
      :nagios_group     => "nagios",
      :backup_dir       => "/var/nagyo/backup",
      :nagios_object_dirs => %W(clusters commands contacts hardware hostgroups hosts services),

      # when creating hosts, things are required
      :default_contact  => "pobrien@eharmony.com",

    })

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


    # TODO: can we use actionmailer? 
    def self.send_email(from, to, subject, message, *cc)
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


  end # Worker

end
