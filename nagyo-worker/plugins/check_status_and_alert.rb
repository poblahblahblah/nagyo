#!/usr/bin/ruby -W0
require 'nventory'
require 'nv_helpers'
require 'optparse'
require 'net/smtp'

###########
# opt parse
###########
options     = {}
opts        = OptionParser.new
opts.banner = 'Usage: ./check_status_and_alert.rb -H <host> -s <status> -a <arbitrary string>'
opts.separator "Arguments"

opts.on("-H", "--host <host>", "hostname to alert on") do |opt|
  options[:host] = opt
end
opts.on("-s", "--status <status>", "WARN, CRIT, UNKNOWN, etc.") do |opt|
  options[:status] = opt
end
opts.on("-a", "--alert_subject <subject>", "Subject of the Alert") do |opt|
  options[:alert_subject] = opt
end
opts.on("-b", "--alert_body <body>", "Body of the Alert") do |opt|
  options[:alert_body] = opt
end
opts.on("-e", "--email <email>", "email destination for alert.") do |opt|
  options[:email] = opt
end

opts.on("-h", "--help", "Show this help message.") do
  puts opts
  exit 255
end

opts.parse(ARGV)
message = options[:message]
(puts opts ; exit 255) if options.empty?

def get_node_status(node)
  begin
    nvclient = NVentory::Client.new(:server => 'http://nventory.corp.eharmony.com', :cookiefile => '/tmp/.nvcookie')
    results  = nvclient.get_objects(:objecttype => 'nodes', 
                                    :get => { :name => node}, 
                                    :includes => [ 'status' ]
                                   )
  rescue => exception
    #send_email
  end

  return results[node]['status']['name']
end

# method to send out an email
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

node_status = get_node_status(options[:host])

if node_status =~ /(inservice$)/
  # if we get here the host should be inservice so we *should* alert on it.
  subject = "#{options[:status]}: #{options[:alert_subject]}"
  send_email('monitoring@eharmony.com', options[:email], subject, options[:alert_body])
  puts options[:email], subject, options[:alert_body]
  exit 0
else
  # if the node is anything but "inservice" we'll just want to drop this
  # alert on the floor since we're going to assume that the node is
  # being rebuilt/deployed to/otherwise unavailable on purpose.
  exit 0
end

