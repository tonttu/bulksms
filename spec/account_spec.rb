
require 'spec_helper'

describe Bulksms::Account do

  before :all do
    Bulksms.config.username = "fooobar"
    Bulksms.config.password = "passs"
  end

  describe "initialisation" do

    it "should set initial values" do
      @account = Bulksms::Account.new
      @account.username.should eql("fooobar")
      @account.password.should eql("passs")
    end

    it "should allow override of attirbutes" do
      @account = Bulksms::Account.new(:username => 'bardom', :password => "fooooed")
      @account.username.should eql('bardom')
      @account.password.should eql('fooooed')
    end

  end

  describe "methods" do

    before :each do
      @account = Bulksms::Account.new
    end

    describe "#to_params" do
      it "should return hash of username and password" do
        @account.to_params.should eql('username' => 'fooobar', 'password' => 'passs')
      end
    end

    describe "#credits" do

      before :all do
        @conf = Bulksms.config
      end

      it "returns credits on success" do
        FakeWeb.register_uri(:post, "http://#{@conf.host}:#{@conf.port}#{@conf.credits_path}", :body => "0|302.3")
        @account.credits.should eql(302.3)
      end

      it "raises an error when request fails" do
        FakeWeb.register_uri(:post, "http://#{@conf.host}:#{@conf.port}#{@conf.credits_path}", :body => "23|Authentication failed")
        expect { @account.credits }.to raise_error Bulksms::AccountError, /Authentication/
      end

    end

  end

end
