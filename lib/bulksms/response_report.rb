module Bulksms
  class ResponseReport

    attr_reader :raw_response, :code, :result, :detail

    def initialize(raw_response, code, result, detail)
      @raw_response = raw_response
      @code         = code
      @result       = result
      @detail       = detail
    end

    def success?
      @code == 0
    end

    def self.parse(response_text)
      tokens = response_text.split("\n\n")

      request_status = tokens[0].split('|')
      detail = tokens[1].split("\n").collect do |d|
        tmp = d.split('|')
        tmp[1] = ResponseReport.description(tmp[1])
        tmp
      end
      new response_text, request_status[0].to_i, request_status[1], detail
    end

    def self.description(code)
      case code.to_i
        when 0
          "In progress (a normal message submission, with no error encountered so far)."
        when 10
          "Delivered upstream"
        when 11
          "Delivered to mobile"
        when 12
          "Delivered upstream unacknowledged (assume message is in progress)"
        when 22
          "Internal fatal error"
        when 23
          "Authentication failure"
        when 24
          "Data validation failed"
        when 25
          "You do not have sufficient credits"
        when 26
          "Upstream credits not available"
        when 27
          "You have exceeded your daily quota"
        when 28
          "Upstream quota exceeded"
        when 29
          "Message sending cancelled"
        when 31
          "Unroutable"
        when 32
          "Blocked (probably because of a recipient's complaint against you)"
        when 33
          "Failed"
        when 40
          "Temporarily unavailable"
        when 50
          "Delivery failed - generic failure"
        when 51
          "Delivery to phone failed"
        when 52
          "Delivery to network failed"
        when 53
          "Message expired"
        when 54
          "Failed on remote network"
        when 56
          "Failed"
        when 57
          "Failed due to fault on handset (e.g. SIM full)"
        when 60
          "Transient upstream failure (transient)"
        when 61
          "Upstream status update (transient)"
        when 62
          "Upstream cancel failed (transient)"
        when 63
          "Queued for retry after temporary failure delivering (transient)"
        when 64
          "Queued for retry after temporary failure delivering, due to fault on handset (transient)"
        when 70
          "Unknown upstream status"
        else
          code
      end
    end

  end
end
