
require 'spec_helper'

describe Bulksms::Message do

  describe "initialize" do

    it "should instantiate" do
      Bulksms::Message.new.should be_a(Bulksms::Message)
    end

    it "should accept message payload details" do
      @msg = Bulksms::Message.new :message => "foo", :recipient => "1234"
      @msg.message.should eql("foo")
      @msg.recipient.should eql("1234")
    end

    it "should allow overrides" do
      @msg = Bulksms::Message.new :message => "foo", :recipient => '1234', :routing_group => 3,
        :test_always_succeed => 1, :message_class => 1
      @msg.routing_group.should eql(3)
      @msg.msg_class.should eql(1)
      @msg.test_always_succeed.should eql(1)
    end

  end


  describe "#to_params" do

    it "should return a hash of parameters" do
      @msg = Bulksms::Message.new :message => "foo", :recipient => "1234"
      @msg.to_params['message'].should eql('foo')
      @msg.to_params['msisdn'].should eql('1234')
    end

    it "should raise an error if recipient is missing" do
      @msg = Bulksms::Message.new :message => "foo"
      expect { @msg.to_params }.to raise_error /recipient/
    end

    it "should raise an error if message is missing" do
      @msg = Bulksms::Message.new :recipient => "1234"
      expect { @msg.to_params }.to raise_error /message/
    end

  end

end
