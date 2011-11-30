require 'spec_helper'

describe Bulksms::Configuration do

  before :each do
    @config = Bulksms::Configuration.new
  end

  describe "accessors" do
    it "should be provided" do
      [:username, :password, :country, :host, :port, :message_path,
        :credits_path, :message_class, :routing_group].each do |accessor|
        @config.should respond_to accessor
      end
    end
  end

  describe "initialize" do

    it "should set defaults" do
      @config.country.should eql(:international)
      @config.port.should eql(5567)
      @config.message_path.should_not be_empty
      @config.credits_path.should_not be_empty
      @config.message_class.should eql(2)
      @config.routing_group.should eql(2)
    end

  end

  describe "#host" do

    it "should provide international host by default" do
      @config.host.should eql('bulksms.vsms.net')
    end

    it "should provide hostname from country if blank" do
      @config.country = :uk
      @config.host.should eql('www.bulksms.co.uk')
    end

    it "should provide host name if set" do
      @config.host = "some.host"
      @config.host.should eql("some.host")
    end

  end

end

