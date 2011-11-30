
require 'cgi'

module Bulksms

  class AccountError < Exception; end

  class Account

    attr_reader :username, :password, :host, :port

    def initialize(opts = {})
      opts ||= { }
      @username = opts[:username] || Bulksms.config.username
      @password = opts[:password] || Bulksms.config.password
      @host     = opts[:host] || Bulksms.config.host
      @port     = opts[:port] || Bulksms.config.port
    end

    def to_params
      { 'username' => @username, 'password' => @password }
    end

    def credits
      res = request Bulksms.config.credits_path
      raise(AccountError, res.result, caller) if res.code != 0
      res.result.to_f
    end

    def request(path, params = {})
      response = nil
      connection do |http|
        if params.is_a?(Array)
          response = params.map{|p| post(http, path, p)}
        else
          response = post(http, path, params)
        end
      end
      response
    end

    protected

    def post(http, path, params = {})
      payload = params_to_query_string(to_params.merge(params))
      response = http.post path, payload
      Response.parse(response.body)
    end

    def connection
      Net::HTTP.start(host, port) do |http|
        yield http
      end
    end

    def params_to_query_string(params)
      params.collect{|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.join('&')
    end

  end

end
