require 'spec_helper'

describe Sidekiq::ResetStatistics::Web do
  include Rack::Test::Methods

  STATS = %w(processed failed).freeze unless defined?(STATS)

  def app
    @app ||= Sidekiq::Web
  end

  before do
    Sidekiq.redis do |conn|
      conn.flushdb
      STATS.each { |stat| conn.set("stat:#{stat}", 5) }
    end
  end

  it 'should display the index page' do
    get '/reset-statistics'
    last_response.status.should == 200
  end

  it 'should reset all statistics in Sidekiq by default' do
    post '/reset-statistics'
    last_response.status.should == 302

    Sidekiq.redis do |conn|
      STATS.each { |stat| conn.get("stat:#{stat}").should == '0' }
    end
  end

  it 'should reset all statistics in Sidekiq when asked' do
    post '/reset-statistics', :reset_all => 'Reset All'
    last_response.status.should == 302

    Sidekiq.redis do |conn|
      STATS.each { |stat| conn.get("stat:#{stat}").should == '0' }
    end
  end

  STATS.each do |stat|
    it "should reset #{stat} when asked" do
      post '/reset-statistics', "reset_#{stat}" => "Reset #{stat.capitalize}"
      last_response.status.should == 302

      Sidekiq.redis do |conn|
        conn.get("stat:#{stat}").should == '0'
      end
    end
  end

  context 'version mismatch' do
    before do
      method_class          = String.method(:new).class
      instance_method_class = String.instance_method(:size).class
      method_class.any_instance.stub(:arity => 0)
      instance_method_class.any_instance.stub(:arity => 0)
    end

    it 'should not raise an error when requested action is compatible with sidekiq' do
      post '/reset-statistics', :reset_all => 'Reset All'
      last_response.status.should == 302

      Sidekiq.redis do |conn|
        STATS.each { |stat| conn.get("stat:#{stat}").should == '0' }
      end
    end

    it 'should raise an error when requested action is incompatible with sidekiq' do
      post '/reset-statistics', :reset_foo => 'Reset Foo'
      last_response.status.should == 500
      last_response.errors.should include('Version mismatch. Please upgrade Sidekiq')
    end
  end
end
