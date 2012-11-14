# helper to CRUD nagyo server objects using the REST api
# 
# deals in Hashes - no model objects here

require 'json'
#require 'cgi'
require 'rest_client'

require 'nokogiri'
require 'open-uri'

# require 'active_support/core_ext/object/to_query'

module Nagyo::Worker

  #
  # Example
  #
  #    nagyo = Nagyo::Worker::ServerHelper.new(
  #               :nagyo_host => "http://localhost:3000/",
  #               :auth_token => "b4j5qBqzYx5EukCM3Vri"
  #            )
  #    periods = nagyo.get_all("Timeperiods")
  #    twenty4seven = nagyo.get("timeperiod", "24x7")
  #
  #    newone = nagyo.create("timeperiod",
  #                          :timeperiod_name => "another period")
  #
  class ServerHelper
    def config
      Nagyo::Worker.config
    end
    def logger
      Nagyo::Worker.logger
    end

    attr_accessor :nagyo_host, :auth_token, :nagyo, :raise_errors

    def initialize(nagyo_host = nil, auth_token = nil, raise_errors = false)
      # need a nagyo server host, port and base URI
      self.nagyo_host = nagyo_host || Nagyo::Worker.config[:nagyo_host]
      self.auth_token = auth_token || Nagyo::Worker.config[:nagyo_auth_token] # 'b4j5qBqzYx5EukCM3Vri'
      self.raise_errors = raise_errors

      self.config_nagyo
    end

    def config_nagyo
      self.nagyo = RestClient::Resource.new(self.nagyo_host, self.auth_token)
    end


    # CRUD operations - by model class, id
    # want json for pulling data
    def get_all(model, opts = {})
      name = model_name(model)
      do_restful_action("get_all", name) do
        all_opts = {:format => :json, :accept => :json, :params => {:all => 'true'}}
        self.nagyo["#{name}"].get(all_opts.merge(opts))
      end
    end

    # want json for pulling data
    def get(model, id, opts = {})
      name = model_name(model)
      data = do_restful_action("get", name) do
        self.nagyo["#{name}/#{URI.encode(id)}"].get(opts.merge(:format => :json, :accept => :json))
      end
      # NOTE: if we get a Hash - single record matched - otherwise when no 
      # match it will return all records in an Array ...
      if data.is_a?(Hash)
        return data
      end
    end

    # for update, create in :json or :html mode, when we get a "302 Found" 
    # response, means it worked. But - if we pretend to be javascript (not 
    # json) with :format => :js then it will return a json hash with "id": 
    # "0123abc..." 
    #
    #
    # TODO: what about csrf auth token? disable on whole app? or figure out a 
    # proper json api for rails-admin
    #
    # NOTE: these opts cause much fail: :accept => :json, :format => :json. 
    # rails-admin actions seem to only look for format.html or format.js, 
    # will succeed in creating or updating record but then fails rendering JSON 
    # with "406 Not Acceptable" for :accept => :json or :format => :json :(
    #

    def update(model, id, opts = {})
      name = model_name(model)
      do_restful_action("update", name) do
        self.nagyo["#{name}/#{URI.encode(id)}/edit"].put(:format => :js, name => opts)
      end
    end

    #
    def create(model, opts = {})
      name = model_name(model)
      do_restful_action("create", name) do
        # TODO: return id? json-parse response? rails-admin does not do json 
        # here only html - may need to parse for model errors or else get  406 
        # Not Acceptable response
        #
        # NOTE: when successful, returns: RestClient::Found: 302 Found, redirects 
        # to index of model ... (without :accept or :format, that is)
        #
        # NOTE: when not success: returns: RestClient::NotAcceptable: 406 Not 
        # Acceptable
        #
        self.nagyo["#{name}/new"].post(:format => :js, name => opts)
      end
    end

    def delete(model, id, opts = {})
      # NOTE: the :accept => :json is causing rails-admin to barf ... which 
      # means rails_admin delete action may not be able to respond to 
      # json/javascript or is expecting a confirmation for DELETE - is it 
      # expecting auth_token??
      #
      # FIXME: TODO: delete wants a deletion confirmation ... how to give that 
      # in API request?
      #
      name = model_name(model)
      do_restful_action("delete", name) do
        self.nagyo["#{name}/#{URI.encode(id)}/delete"].delete(opts.merge(:_method => :delete, :format => :js))
      end
    end

  private

    def model_name(model)
      model.to_s.downcase
    end

    # perform the code in &block (rest-client call) and process the result
    def do_restful_action(action, model, &block)
      begin
        # do block
        response = yield
        return parse_response(response)

      rescue RestClient::NotAcceptable => u
        # we might be able to glean errors from HTML in response
        logger.debug("Nagyo.#{action}:#{model}: #{u}")
        error = parse_response(u.response)
        raise Exception.new([Exception.new(error), u]) if self.raise_errors
      rescue Exception => e
        logger.error("Nagyo.#{action}:#{model}: #{e}")
        raise e if self.raise_errors
      end
    end


    # NOTE: can't trust content-type - sometimes returns text/javascript 
    # but is actually HTML error page
    def parse_response(response)
      begin
        data = JSON.parse(response.to_s)
        return data
      rescue JSON::ParserError
        # try as HTML
        logger.debug("Error parsing JSON response, now trying HTML ...")
        data = Nokogiri::HTML(response.to_s)
        errors = data.css("div.error span.help-inline").map(&:text)
        logger.warn("Nagyo Model errors: #{errors.inspect}")
        return errors
      rescue Exception => e
        logger.error("Errors parsing response: #{e}: #{e.inspect}")
        raise e if self.raise_errors
      end
    end



  end
end

