require 'open-uri'

#gem 'rest-client', '>= 1.6.7'
require 'rest_client'

# TODO: can we use Nagyo::Server::Helper here?  how to get it installed 
# - rpm / gem? -- chef needs it on machine before it loads libraries ... 
# ?
require 'nagyo-server-helper'

# Used in providers/nagyo_helper to add or update a resource
#
module NagyoHelper
  # Nagyo Server URL
  # TODO: make this more configurable, e.g. yml file like nagyo-worker?
  BASE_URL = 'http://nagios2.np.dc1.eharmony.com:3000'

  def self.add_or_update(resource)
    model_name = resource.model_name
    base_url = (resource.nagyo_url || BASE_URL)

    # each resource could have it's own nagyo url so make it fresh
    nagyo = Nagyo::Server::Helper.new(base_url)

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
      Chef::Log.info(e)
    end
  end
end
