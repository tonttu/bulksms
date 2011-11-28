
require 'spec_helper'

describe Bulksms do

  it "should exist" do
    Bulksms.should be_a(Module)
  end

  describe "#config" do

    it "should be provided" do
      Bulksms.config.should be_a(Bulksms::Configuration)
    end

    it "should accept a block to set config options" do
      Bulksms.config.username = ""
      Bulksms.config do |c|
        c.username = "foobar"
      end
      Bulksms.config.username.should eql('foobar')
    end

  end

  describe "#deliver" do

    it "should exist" do
      Bulksms.should respond_to(:deliver)
    end

    it "should send a message" do
      service = mock(:Service)
      service.should_receive(:deliver)
      Bulksms::Service.should_receive(:new).with({}).and_return(service)
      Bulksms.deliver(:message => "Test", :recipient => "123456")
    end

    it "should send a message with opts" do
      opts = {:opts => 'bar'}
      service = mock(:Service)
      service.should_receive(:deliver)
      Bulksms::Service.should_receive(:new).with(opts).and_return(service)
      Bulksms.deliver({:message => "Test", :recipient => "123456"}, opts)
    end


  end

  describe "#credits" do

    it "should exist" do 
      Bulksms.should respond_to(:credits)
    end

    it "should request credits" do
      account = mock(:Account)
      account.should_receive(:credits)
      Bulksms::Account.should_receive(:new).with({}).and_return(account)
      Bulksms.credits
    end

    it "should pass options to account" do
      opts = {:opts => 'bar'}
      account = mock(:Account)
      account.should_receive(:credits)
      Bulksms::Account.should_receive(:new).with(opts).and_return(account)
      Bulksms.credits(opts)
    end


  end

end
