
require "net/http"
require "uri"
require "bulksms/version"
require "bulksms/configuration"
require "bulksms/message"
require "bulksms/account"
require "bulksms/service"
require "bulksms/response"

if defined?(Rails)
  require "bulksms/railtie"
end

module Bulksms
  extend self

  def config
    @config ||= Configuration.new
    yield @config if block_given?
    @config
  end

  # Simple wrapper for sending SMS messages via BulkSMS API.
  # The most simple message should be provided as a hash as follows:
  #
  #     {
  #       :message => "Body of message to send",
  #       :recipient => "+34644477123"
  #     }
  #
  # An array of messages may also be provided to send multiple SMS
  # in the same HTTP connection.
  #
  def deliver(*args)
    msg  = args.shift
    opts = args.shift || {}
    service = Service.new(opts)
    service.deliver(msg)
  end

  # Request the number of credits available in your account.
  # Returns a single float if successful, or raises an AccountError exception.
  def credits(*args)
    opts = args.last || { }
    account = Account.new(opts)
    account.credits
  end

end
