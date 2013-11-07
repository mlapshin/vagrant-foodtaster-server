require 'bundler/setup'
require 'foodtaster'

PROJECT_ROOT = '/tmp/vagrant-foodtaster-server'

RSpec.configure do |config|
  config.color_enabled = true
end

Foodtaster.configure do |config|
  config.log_level = :debug
end
