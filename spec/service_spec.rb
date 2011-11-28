require 'spec_helper'

describe Bulksms::Service do

  describe "initialization" do

    it "instantiates account with options" do
      opts = {:random => 'stuff'}
      Bulksms::Account.should_receive(:new).once.with(opts)
      Bulksms::Service.new(opts)
    end

  end

  describe "#deliver" do

    before :each do
      @service = Bulksms::Service.new
      @service.stub!(:send_request)
    end

    it "should convert hash into message" do
      msg = {:message => "Foooo", :recipient => "1232131"}
      Bulksms::Message.should_receive(:new).once.with(msg)
      @service.deliver(msg)
    end

    it "should convert hash array into message array" do
      msgs = [{:message => "Foooo", :recipient => "1232131"}, {:message => "Foooo", :recipient => "1232131"}]
      Bulksms::Message.should_receive(:new).once.with(msgs[0])
      Bulksms::Message.should_receive(:new).once.with(msgs[1])
      @service.deliver(msgs)
    end

    it "should not do anything to a real Message" do
      msg = Bulksms::Message.new(:message => "foobar", :recipient => "123344544")
      @service.should_receive(:send_request).with(msg)
      @service.deliver(msg)
    end

  end

  describe "#send_request" do

    before :each do
      @service = Bulksms::Service.new
    end

    it "should convert messages to params" do
      msg = Bulksms::Message.new(:message => 'test', :recipient => '1234')
      @service.account = mock(:Account)
      @service.account.should_receive(:request).with(Bulksms.config.message_path, msg.to_params)
      @service.send(:send_request, msg)
    end

  end


end

