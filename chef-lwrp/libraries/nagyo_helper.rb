#gem 'rest-client', '>= 1.6.7'
require 'rest_client'

module NagyoHelper
  BASE_URL = 'http://nagios2.np.dc1.eharmony.com:3000'

  def self.add_or_update(resource)
    base_url = (resource.nagyo_url || BASE_URL) + "/" + resource.model_name
    model_name = resource.model_name
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

      # FIXME: TODO: i don't think this is best way to pull objects -- ?
      # e.g. why use Service.[:nodegroup, :check_command, :contacts, 
      # :notification_period] when you can just use Service.name ?
      #
      # TODO: Try to limit get_params to single key and use Mongoid::Slug
      # -- otherwise, some objects will need more finder methods or find by _id 
      # instead (e.g.  servicedependency ... has no unique key other than _id 
      # ...)
      #   /service/:id
      #   /service/:name
      get_params = get_params.collect { |k, v| "#{k.to_s}=#{CGI::escape(v.to_s)}" }.join('&')    
      response = RestClient.get base_url + ".json?#{get_params}"

      result = JSON.parse(response)
      if !result.empty? # Update if this is for existing object
        object_id = result.first['id']
        ret = RestClient.put "#{base_url}/#{object_id}", model_name => params 
      else # Create if this is for a new object
        ret = RestClient.post base_url, model_name => params 
      end
    rescue => e
      Chef::Log.info(e)
    end
  end  
end
