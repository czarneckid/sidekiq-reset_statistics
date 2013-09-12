require 'spec_helper'

describe 'Sidekiq::ResetStatistics::VERSION' do
  it 'should be the correct version' do
    Sidekiq::ResetStatistics::VERSION.should == '1.0.0'
  end
end