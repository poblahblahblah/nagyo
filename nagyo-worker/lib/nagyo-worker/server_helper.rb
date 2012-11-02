# helper to CRUD nagyo server objects using the REST api
# 
# deals in Hashes - no model objects here

require 'json'
require 'cgi'
require 'rest_client'

module Nagyo::Worker

  #
  # Example
  #
  #    nagyo = Nagyo::Worker::ServerHelper.new(
  #
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

    def initialize(nagyo_host = nil, auth_token = nil)
      # need a nagyo server host, port and base URI
      self.nagyo_host = nagyo_host || Nagyo::Worker.config[:nagyo_host]
      self.auth_token = auth_token || Nagyo::Worker.config[:nagyo_auth_token] # 'b4j5qBqzYx5EukCM3Vri'
      self.raise_errors = true

      self.nagyo = RestClient::Resource.new(self.nagyo_host, self.auth_token)
    end

    # CRUD operations - by model class, id
    # want json for pulling data
    def get_all(model, opts = {})
      name = model_name(model)
      begin
        response = self.nagyo["#{name}"].get(opts.merge(:format => :json, :accept => :json))
        data = JSON.parse(response)
        return data
      rescue Exception => e
        logger.error("Nagyo.get_all:#{name}: #{e}")
        raise e if self.raise_errors
      end
    end

    # want json for pulling data
    def get(model, id, opts = {})
      name = model_name(model)
      begin
        response = self.nagyo["#{name}/#{CGI.escape(id)}"].get(opts.merge(:format => :json, :accept => :json))
        data = JSON.parse(response)

        # NOTE: if we get a Hash - single record matched - otherwise when no 
        # match it will return all records in an Array ...
        if data.is_a?(Hash)
          return data
        end
      rescue Exception => e
        logger.error("Nagyo.get:#{name}: #{e}")
        raise e if self.raise_errors
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
      begin
        response = self.nagyo["#{name}/#{CGI.escape(id)}/edit"].put(:format => :js, name => opts)
        data = JSON.parse(response)
        return data
      rescue Exception => e
        logger.error("Nagyo.update:#{name}: #{e}")
        raise e if self.raise_errors
      end
    end

    #
    def create(model, opts = {})
      name = model_name(model)
      begin
        # TODO: return id? json-parse response? rails-admin does not do 
        # json here only html - may need to parse for model errors or 
        # else get  406 Not Acceptable response
        #
        # NOTE: when successful, returns: RestClient::Found: 302 Found, redirects 
        # to index of model ... (without :accept or :format, that is)
        #
        # NOTE: when not success: returns: RestClient::NotAcceptable: 406 Not 
        # Acceptable
        #
        response = self.nagyo["#{name}/new"].post(:format => :js, name => opts)
        data = JSON.parse(response)
        return data
      rescue Exception => e
        logger.error("Nagyo.create:#{name}: #{e}")
        raise e if self.raise_errors
      end
    end

    def destroy(model, id, opts = {})
      # NOTE: the :accept => :json is causing rails-admin to barf ... which 
      # means rails_admin delete action may not be able to respond to 
      # json/javascript or is expecting a confirmation for DELETE - is it 
      # expecting auth_token??
      #
      # FIXME: TODO: delete wants a deletion confirmation ... how to give that 
      # in API request?
      #
      name = model_name(model)
      begin
        response = self.nagyo["#{name}/#{CGI.escape(id)}/delete"].delete(opts.merge(:_method => :delete, :format => :js))
      rescue Exception => e
        logger.error("Nagyo.create:#{name}: #{e}")
        raise e if self.raise_errors
      end
    end

  private

    def model_name(model)
      model.to_s.downcase
    end

  end
end

