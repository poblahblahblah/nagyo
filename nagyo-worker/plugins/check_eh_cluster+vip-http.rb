#!/usr/bin/ruby -W0
require 'nventory'
require 'nv_helpers'
require 'optparse'
require 'net/http'

###########
# opt parse
###########
options     = {}
opts        = OptionParser.new
opts.banner = 'Usage: check_eh_cluster-http.rb -H <host_list> -c <critical> -w <warn> -u <ecv uri> -e <ecv string>'
opts.separator "Arguments"

opts.on("-H", "--hostlist <hostlist>", "comma separated host list") do |opt|
  options[:hostlist] = opt
end
opts.on("-c", "--critical <critical level>", "critical percentage") do |opt|
  options[:critical] = opt
end
opts.on("-w", "--warn <warn level>", "warn percentage") do |opt|
  options[:warn] = opt
end
opts.on("-u", "--ecv_uri <ecv uri>", "ecv uri to check") do |opt|
  options[:ecv_uri] = opt
end
opts.on("-e", "--ecv_string <ecv string>", "expected ecv response") do |opt|
  options[:ecv_string] = opt
end
opts.on("-V", "--vip_name <vip name>", "name of VIP in nventory to monitor") do |opt|
  options [:vip_name] = opt
end
opts.on("-h", "--help", "Show this help message.") do
  puts opts
  exit 255
end

opts.parse(ARGV)
message = options[:message]
(puts opts ; exit 255) if options.empty?

def check_ecv(url, ecv_uri)
  begin
    url = URI.parse("http://" + url)
    http = Net::HTTP.new(url.host, url.port)
    resp = http.get(ecv_uri)
    return resp.body
  rescue
    return "could not connect to host."
  ensure
    http.finish if http && http.active?
  end
end

hosts_to_check = options[:hostlist].split(',')
up_hosts       = []
down_hosts     = []
nvclient       = NVentory::Client.new(:server => 'http://nventory.corp.eharmony.com', :cookiefile => '/tmp/.nvcookie')

# there is currently no status for VIPs, so we'll fake it for now.
vip            = nvclient.get_objects(:objecttype => 'vips', :get => { :name => options[:vip_name]})
vip['status'] = {}
vip['status']['name'] = "inservice"

if vip['status']['name'] == "deploy"
  # if we get here that means that there is currently a deploy happening,
  # in which case we'll just want to exit cleanly - no point in doing the 
  # actual ecv checks.
  puts "OK: Deploy currently in progress, ignoring ecv failures."
  exit 0
end

hosts_to_check.each do |url|
  Thread.new do
    result     = check_ecv(url, options[:ecv_uri])
    up_hosts   << url if result == options[:ecv_string]
    down_hosts << url if result != options[:ecv_string]
  end
end

sleep 1 until Thread.list.size == 1

if up_hosts.count == hosts_to_check.count
  puts "OK: all ecv checks passed."
  exit 0
elsif down_hosts.count == hosts_to_check.count
  puts "CRITICAL: all ecv checks failed."
  exit 2
else
  alive_percentage = down_hosts.count / down_hosts.count.to_f
  if alive_percentage > options[:critical].to_f
    # enough hosts down to be critical - let's alert
    puts "CRITICAL: #{alive_percentage}% of ecv checks failed:"
    puts down_hosts.count.join("\n")
    exit 2
  elsif alive_percentage > options[:warn].to_f
    # enough hosts are down to warn, but not be critical - let's warn
    puts "WARNING: #{alive_percentae}% of ecv checks failed:"
    puts down_hosts.count.join("\n")
    exit 1
  else
    # some hosts are down, but haven't breached the crit or warn threshold - let's return OK
    puts "OK: #{alive_percentae}% of ecv checks failed:"
    puts down_hosts.count.join("\n")
    exit 0
  end
end

