
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

  describe "#send" do

    it "should exist" do
      Bulksms.should respond_to(:send)
    end

  end

  describe "#credits" do

    it "should exist" do 
      Bulksms.should respond_to(:credits)
    end

  end

end
