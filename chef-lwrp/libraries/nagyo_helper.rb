require 'open-uri'

#gem 'rest-client', '>= 1.6.7'
require 'rest_client'

# TODO: can we use Nagyo::Server::Helper here?  how to get it installed - rpm / 
# gem? -- chef needs it on machine before it loads libraries ... ?
require 'nagyo-server-helper'

# Used in providers/nagyo_helper to add or update a resource
#
module NagyoHelper
  # Nagyo Server URL
  # TODO: make this more configurable, e.g. yml file like nagyo-worker?
  BASE_URL = 'http://nagios2.np.dc1.eharmony.com:3000'

  # can this work as a class/module level instead of instance level?
  # TODO: research chef-lwrp docs for how this is included
  def self.nagyo
    @nagyo ||= Nagyo::Server::Helper.new(BASE_URL)
  end

  def self.add_or_update(resource)
    model_name = resource.model_name
    base_url = (resource.nagyo_url || BASE_URL) + "/" + model_name

    ## ...
    params = {}
    resource.my_attr_keys.each do |attr|
      params[attr] = resource.send(attr) if resource.respond_to?(attr)
    end

    begin
      get_params = {}
      # See if object already exist
      resource.get_attrs.each do |attr|
        get_params[attr] = resource.send(attr) if resource.respond_to?(attr)
      end

      # try to find the model's id key
      id_key = nagyo.model_keys[model_name.to_sym] rescue nil
      id_val = get_params[id_key] if id_key
      # TODO: delete id from get_params if found?

      # TODO: for those models that still need multiple keys, provide a utility 
      # in NagyoHelper to convert params into a set of rails_admin filters ...

      result = nagyo.create_or_update(model_name, id_val, get_params)
    rescue => e
      Chef::Log.info(e)
    end
  end
end
