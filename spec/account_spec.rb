# encoding: utf-8

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

    describe "#request" do
      # TODO: fix: These tests are slightly flawed as they do not test the parameters.

      before :all do
        @conf = Bulksms.config
      end

      it "will send single request to server" do
        FakeWeb.register_uri(:post, "http://#{@conf.host}:#{@conf.port}/test", {:body => "0|OK|1234"})
        @account.request("/test", {:foo => :bar}).success?.should be_true
      end

      it "will send bad single request to server" do
        FakeWeb.register_uri(:post, "http://#{@conf.host}:#{@conf.port}/test", {:body => "22|Internal fatal error|1234"})
        @account.request("/test", {:foo => :bar}).success?.should be_false
      end

      it "will send multiple requests to server" do
        FakeWeb.register_uri(:post, "http://#{@conf.host}:#{@conf.port}/test", [{:body => "0|OK|1234"}, {:body => "0|OK|1234"}])
        res = @account.request("/test", [{:foo => :bar}, {:foo => :bar}])
        res.should be_a(Array)
        res[0].success?.should be_true
        res[1].success?.should be_true
      end

    end

    describe "#params_to_query_string" do
      it "converts normal params to string" do
        txt = @account.send(:params_to_query_string, :msg => "Random cháráctérs -and- symbols +34123123123", :some => :symbol)
        txt.should include("Random+ch%E1r%E1ct%E9")
        txt.should include("%2B34123")
        txt.should include("some=symbol")
      end

      it "converts special characters in params to string" do
        txt = @account.send(:params_to_query_string, :msg => "[special] {characters} tilde~ pipe| hat^ euro€")
        txt.should include("%BB%3Cspecial%BB%3E")
        txt.should include("%BB%28characters%BB%29")
        txt.should include("tilde%BB%3D")
        txt.should include("pipe%BB%40")
        txt.should include("hat%BB%14")
        txt.should include("euro%BB%65")
      end

    end

  end

end
