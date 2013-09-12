require 'rspec'
require 'sidekiq-reset_statistics'
require 'rack/test'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end

require 'sidekiq'
Sidekiq.logger.level = Logger::ERROR
