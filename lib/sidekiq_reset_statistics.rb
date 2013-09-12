require 'sidekiq/web'
require 'sidekiq_reset_statistics/version'
require 'sidekiq_reset_statistics/web'

Sidekiq::Web.register Sidekiq::ResetStatistics::Web
Sidekiq::Web.tabs["Reset Statistics"] = "reset-statistics"

module Sidekiq
  module ResetStatistics
  end
end