module Bulksms

  class Configuration

    attr_accessor :username
    attr_accessor :password
    attr_accessor :country
    attr_accessor :host
    attr_accessor :port
    attr_accessor :message_path
    attr_accessor :credits_path
    attr_accessor :message_class

    def initialize
      # Prepare default options
      self.country = :international
      self.port = 5567
      self.message_path = "/eapi/submission/send_sms/2/2.0"
      self.credits_path = "/eapi/user/get_credits/1/1.1"
      self.message_class = 2
    end

    # Overide the default host config so that a short name will be converted
    # into a full hostname.
    def host
      return @host unless @host.to_s.empty?
      case @country
      when :uk
        'www.bulksms.co.uk'
      when :usa
        'usa.bulksms.com'
      when :safrica
        'bulksms.2way.co.za'
      when :spain
        'bulksms.com.es'
      else # :international
        'bulksms.vsms.net'
      end
    end

  end

end
