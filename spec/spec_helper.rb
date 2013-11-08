require 'bundler/setup'
require 'foodtaster'

require 'support/test_client'

PROJECT_ROOT = '/tmp/vagrant-foodtaster-server'
SERVER_PORT = 31415
SERVER_IP = '10.0.2.15'

RSpec.configure do |config|
  config.color_enabled = true
end

Foodtaster.configure do |config|
  config.log_level = :debug
end

def execute_on(vm, command)
  vm.execute_as('vagrant', <<-BASH.chomp)
    cd #{PROJECT_ROOT}/spec/environment && \
  #{command}
  BASH
end

def run_server_on(vm, opts={})
  command = "vagrant foodtaster-server #{SERVER_IP}:#{SERVER_PORT}"
  command << ' &' if opts[:daemon]
  execute_on(vm, command)
end

def client
  @client ||= TestClient.new(SERVER_PORT)
end
