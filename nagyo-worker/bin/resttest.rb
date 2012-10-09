#!/usr/bin/env ruby
#
require 'rest_client'
require 'json'

#BASE_URL = 'http://10.1.64.134:3000'

BASE_URL = 'http://localhost:3000'
#RESOURCE_NAME = "hosts"
RESOURCE_NAME = "host"



def first_way
  # this sends request ...  but there is no host yet ...
  base_url = BASE_URL + "/" + RESOURCE_NAME
  response = RestClient.get base_url + "/pobrien-np-dc1-eharmony-com.json"
  result   = JSON.parse(response)

  p result

  base_url = [BASE_URL, RESOURCE_NAME, "new"].join("/")

  # this puts a new one?
  #RestClient.post base_url, result
  #abort

  new_opts = {
    "host_name" => "pobrien.np.dc1.eharmony.com",
    "alias" => "pobrien.np.dc1.eharmony.com",
    "address" => "pobrien.np.dc1.eharmony.com",
    "max_check_attempts" => 3,
    "notification_interval" => 5,
    "notification_period" => "24x7",
    "check_period" => "24x7",
    "contacts" => ["pat-obrien"],
  }

  ret      = RestClient.post base_url, new_opts.to_json, :content_type => :json, :accept => :json
                                       #}.to_param

  p ret
end


# responses from 'new'.post
# 302 Found (RestClient::Found)
#  - means the redirect after success?

# 406 Not Acceptable (RestClient::NotAcceptable)
#  - if new/updated model invalid/errors

def resource_way
  # TODO: make json default format?

  # try resource style
  #resources = RestClient::Resource.new("#{BASE_URL}/#{RESOURCE_NAME}", 
  #'user@test.com', 'please') #, :accept => :json)
  resources = RestClient::Resource.new("#{BASE_URL}/#{RESOURCE_NAME}", 'b4j5qBqzYx5EukCM3Vri') #token
  # 
  response = resources.get(:accept => :json)
  all_hosts   = JSON.parse(response)
  puts "EXISTING HOSTS: " + all_hosts.inspect

  new_opts = {
    "host_name" => "pobrien.np.dc1.eharmony.com",
    "alias" => "pobrien.np.dc1.eharmony.com",
    "address" => "pobrien.np.dc1.eharmony.com",
    "max_check_attempts" => 3,
    "notification_interval" => 5,
    # 24x7
    #"notification_period" => "24x7",
    "notification_period_id" => "5050cb9ebfa68e0903000001",
    # 24x7
    #"check_period" => "24x7",
    "check_period_id" => "5050cb9ebfa68e0903000001",
    # just using first contact
    #"contacts" => ["pat-obrien"],
    "contact_ids" => ["5051283ebfa68e5757000002"],
  }


  #puts resources['new'].post(NEW_OPTS.to_json, :content_type => :json, :accept 
  #=> :json )
  # NOTE: even though this works and creates a new Host in DB - i still get 406 
  # Not Acceptable response
  #puts resources['new'].post({ RESOURCE_NAME.to_s => new_opts}, :accept => 
  #:json )
  begin
    puts resources['new'].post({ RESOURCE_NAME.to_s => new_opts})
  rescue Exception => e
    puts "ERROR: #{e} = #{e.inspect}"
  end

  

  # now edit the resource ...
end



# do new way?
# first_way
resource_way
