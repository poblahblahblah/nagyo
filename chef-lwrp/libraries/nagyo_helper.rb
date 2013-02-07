
require 'open-uri'

# NOTE: below requirements for nagyo/nagios support ...
begin
  #gem 'rest-client', '>= 1.6.7'
  require 'rest_client'

  # NOTE: chef needs Nagyo helper on machine before it loads libraries ...
  # can build rpm from https://github.com/poblahblahblah/nagyo/nagyo-server-helper
  #
  require 'nagyo-server-helper'
  nagyo_loaded = true
rescue LoadError
  err= "ERROR: Unable to load nagyo-server-helper on this machine ... some functionality will be disabled."
  puts err; Chef::Log.error(err)
  nagyo_loaded = false
end

# Used in providers/nagyo_helper to add or update a resource
#
module NagyoHelper
  # Nagyo Server URL
  # FIXME: TODO: make this more configurable, e.g. yml file like nagyo-worker
  BASE_URL = 'http://nagios2.np.dc1.eharmony.com:3000'
  AUTH_TOKEN = "naygo-token-test-user"

  # TODO: should we just make sure it exists without updating ?  might get 
  # annoying to have chef reloading/re-updating things all the time ...

  #
  def self.add_or_update(resource)
    model_name = resource.model_name
    base_url = (resource.nagyo_url || BASE_URL)
    auth_token = (resource.nagyo_auth_token || AUTH_TOKEN)

    # each resource could have it's own nagyo url so make it fresh
    # also - library may not be available so fail gracefully ... just return
    begin
      nagyo = Nagyo::Server::Helper.new(base_url, auth_token)
      # errors from chef-recipes need to be recognized and corrected
      nagyo.raise_errors = true
    rescue NameError => e
      Chef::Log.error("Unable to use Nagyo functionality: #{e}")
      return
    end

    ## ...
    params = {}
    resource.my_attr_keys.each do |attr|
      params[attr] = resource.send(attr) if resource.respond_to?(attr)
    end

    begin
      get_params = {}
      resource.get_attrs.each do |attr|
        get_params[attr] = resource.send(attr) if resource.respond_to?(attr)
      end

      # nagyo #10: verify that dependent objects exist ...
      # Can we tell what attributes are included explicitly in the 
      # resource block?  Do we use Chef::Resource::EharmonyopsSomething 
      # to create dependent something or just use Nagyo helper
      #

      # TODO: simplify this now we are using server helper ... use 
      # identity attr?

      # TODO: for those models that still need multiple keys, provide a 
      # utility in Nagyo Server Helper to convert params into a set of 
      # rails_admin filters ...

      # try to find the model's id key
      id_key = nagyo.model_keys[model_name.to_sym] rescue nil
      id_val = get_params[id_key] if id_key

      # use full params to create/update?
      # TODO: maybe don't want to overwrite nagyo values with chef-lwrp 
      # defaults all the time?  ... not sure how to limit, maybe have 
      # separate list of update-attributes that will overwrite or only 
      # if not blank ?
      #
      result = nagyo.create_or_update(model_name, id_val, params)
    rescue => e
      Chef::Log.error(e)
    end
  end
end
