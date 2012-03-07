module Bulksms
  class Response

    attr_reader :raw_response, :code, :result, :batch_id

    def initialize(raw_response, code, result, batch_id)
      @raw_response = raw_response
      @code         = code
      @result       = result
      @batch_id     = batch_id
    end

    def success?
      @code == 0
    end

    def self.parse(response_text)
      tokens = response_text.split('|')
      new response_text, tokens[0].to_i, tokens[1], tokens[2].to_i
    end

  end
end
