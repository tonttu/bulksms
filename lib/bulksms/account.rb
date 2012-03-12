# encoding: utf-8

require 'cgi'
require 'iconv'

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

    def report(path, args = {})
      payload = to_params.merge(args).collect{|k,v| "#{k}=#{v.to_s}"}.join('&')
      response = nil
      connection do |http|
        response = http.post path, payload
      end
      ResponseReport.parse(response.body)
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

    # return size of utf8 string encoded for GSM network
    def self.string_length(utf8_string)
      utf8_string = Account.remove_accents utf8_string
      CGI.escape(Iconv.iconv('ISO-8859-15//ignore', 'UTF-8', utf8_string)[0]).gsub(/%[0-9A-F]{2}/) do |match|
        code = GSM0338_EXTENDED_MAP[match]
        code ? "%BB%#{code}" : match
      end.length
    end

    def self.remove_accents string
      UNSUPPORTED_ACCENTS.each {|letter,accents|
        packed = accents.pack('U*')
        rxp = Regexp.new("[#{packed}]", nil)
        string.gsub!(rxp, letter)
      }
      string
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
      params.collect{|k,v| "#{k}=#{encode_cgi_string(v.to_s)}"}.join('&')
    end

    def encode_cgi_string(string)
      string = Account.remove_accents string
      CGI.escape(Iconv.iconv('ISO-8859-15//ignore', 'UTF-8', string)[0]).gsub(/%[0-9A-F]{2}/) do |match|
        code = GSM0338_EXTENDED_MAP[match]
        code ? "%BB%#{code}" : match
      end
    end

    GSM0338_EXTENDED_MAP = {
      '%5E' => '14', # ^
      '%7B' => '28', # {
      '%7D' => '29', # }
      '%5C' => '2F', # \
      '%5B' => '3C', # [
      '%7E' => '3D', # ~
      '%5D' => '3E', # ]
      '%7C' => '40', # |
      '%A4' => '65', # EURO
    }

    # Table of unsupported accented characters in charset GSM 03.38
    UNSUPPORTED_ACCENTS = {
    'E' => [200,202,203],
    'e' => [234,235],
    'A' => [192,193,194,195],
    'a' => [225,226,227],
    'c' => [231],
    'O' => [210,211,212,213],
    'o' => [243,244,245],
    'I' => [204,205,206,207],
    'i' => [237,238,239],
    'U' => [217,218,219],
    'u' => [250,251],
    'Y' => [221],
    'y' => [253,255],
    'ae' => [346],
    'OE' => [188],
    'oe' => [189]
  }

  end

end
