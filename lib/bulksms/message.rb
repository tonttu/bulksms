module Bulksms

  # Encapsulates a message to be sent by the gateway
  class Message

    # The various attributes for a message as defined
    # by the BulkSMS HTTP API. For full details on the
    # different attributes see:
    #  http://www.bulksms.co.uk/docs/eapi/submission/send_sms/
    attr_accessor :message, :recipient, :msg_class,
                  :want_report, :routing_group, :source_id,
                  :test_always_succeed, :test_always_fail,
                  :concat_text_sms, :concat_max_parts

    def initialize(opts = {})
      @message = opts[:message]
      @recipient = opts[:recipient]
      @msg_class = opts[:message_class] || Bulksms.config.message_class
      @want_report = opts[:want_report] || 1
      @routing_group = opts[:routing_group] || Bulksms.config.routing_group
      @source_id = ''
      @test_always_succeed = opts[:test_always_succeed] || 0
      @test_always_fail = opts[:test_always_fail] || 0
      @concat_text_sms = 0
      @concat_max_parts = 2
    end

    # Returns a message as a http query string for use
    # by other gateway services
    def to_params
      raise "Missing message!" if @message.to_s.empty?
      raise "Missing recipient!" if @recipient.to_s.empty?
      {
        'message' => @message,
        'msisdn' => @recipient,
        'msg_class' => @msg_class,
        'want_report' => @want_report,
        'routing_group' => @routing_group,
        'source_id' => @source_id,
        'test_always_succeed' => @test_always_succeed,
        'test_always_fail' => @test_always_fail,
        'allow_concat_text_sms' => @concat_text_sms,
        'concat_text_sms_max_parts' => @concat_max_parts
      }
    end
  end

end
