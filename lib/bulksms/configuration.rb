module Bulksms

  class Configuration

    # Standard connection details
    attr_accessor :username
    attr_accessor :password
    attr_accessor :host
    attr_accessor :port

    # Set the country code when no host has been provided. Should be
    # one of:
    #  :uk, :usa, :safrica, :spain, :international (default)
    attr_accessor :country

    # Path added to host to send a message
    # Known as send_sms method in BulkSMS API.
    attr_accessor :message_path

    # Path added to host to request credits
    attr_accessor :credits_path

    # Path added to host to get report
    attr_accessor :report_path

    # Message Class, 0 (Flash SMS), 1, 2 (default, normal SMS, stored to SIM card), 3.
    attr_accessor :message_class

    # Routing group, possible values are 1, 2, 3
    attr_accessor :routing_group

    def initialize
      # Prepare default options
      self.country = :international
      self.port = 5567
      self.message_path = "/eapi/submission/send_sms/2/2.0"
      self.credits_path = "/eapi/user/get_credits/1/1.1"
      self.report_path  = "/eapi/status_reports/get_report/2/2.0"
      self.message_class = 2
      self.routing_group = 2
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
