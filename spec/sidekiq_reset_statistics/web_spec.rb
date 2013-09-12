require 'spec_helper'

describe Sidekiq::ResetStatistics::Web do
  include Rack::Test::Methods

  before do
    Sidekiq.redis { |conn| conn.flushdb }
  end

  def app
    @app ||= Sidekiq::Web
  end

  it 'should display the index page' do
    get '/reset-statistics'
    last_response.status.should == 200
  end

  it 'should reset statistics in Sidekiq' do
    Sidekiq.redis do |conn|
      conn.set('stat:processed', 5)
      conn.set('stat:failed', 10)
      post '/reset-statistics'
      last_response.status.should == 302
      conn.get('stat:processed').should == '0'
      conn.get('stat:failed').should == '0'
    end
  end
end