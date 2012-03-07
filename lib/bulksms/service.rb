module Bulksms

  class Service

    attr_accessor :account

    def initialize(opts = {})
      @account = Account.new(opts)
    end

    # Send a single message or multiple messages.
    def deliver(*args)
      msg = args.shift
      opts = args.shift || {}
      case msg
      when Hash
        msg = Message.new(msg)
      when Array
        msg = msg.map{|m| m.is_a?(Message) ? m : Message.new(m)}
      end
      send_request(msg)
    end

    def report(*args)
      batch_id = args.shift
      opts     = args.shift || { }
      raise "Missing batch_id!" if batch_id[:batch_id].to_s.empty?
      
      @account.report Bulksms.config.report_path, batch_id.merge(opts)
    end

    protected

    def send_request(msg)
      params = msg.is_a?(Array) ? msg.map{|m| m.to_params} : msg.to_params
      @account.request Bulksms.config.message_path, params
    end

  end

end
