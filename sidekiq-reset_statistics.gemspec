$:.push File.expand_path("../lib", __FILE__)

require 'sidekiq-reset_statistics/version'

Gem::Specification.new do |s|
  s.name        = "sidekiq-reset_statistics"
  s.version     = Sidekiq::ResetStatistics::VERSION
  s.authors     = ["David Czarnecki"]
  s.email       = ["me@davidczarnecki.com"]
  s.homepage    = "https://github.com/czarneckid/sidekiq-reset_statistics"
  s.summary     = %q{Adds a tab to your Sidekiq dashboard to allow you to reset Sidekiq statistics}
  s.description = %q{Adds a tab to your Sidekiq dashboard to allow you to reset Sidekiq statistics}
  s.license = 'MIT'

  s.rubyforge_project = "sidekiq-reset_statistics"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('sidekiq')
  s.add_development_dependency('sinatra')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rack-test')
end
