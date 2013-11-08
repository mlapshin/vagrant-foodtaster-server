require 'bundler/setup'
require 'foodtaster'

require 'support/test_client'

PROJECT_ROOT = File.expand_path('../../', __FILE__)
SERVER_PORT = 31415
SERVER_IP = '10.0.2.15'

RSpec.configure do |config|
  config.color_enabled = true
end

def with_test_root(command)
  <<-BASH
cd #{PROJECT_ROOT}/spec/environment && \
#{command}
  BASH
end

def execute(command)
  system with_test_root(command)
end

def start_server
  @pid = Process.spawn(with_test_root("vagrant foodtaster-server #{SERVER_PORT}"),
                       pgroup: true)
  sleep 1
end

def stop_server
  Process.kill('INT', -@pid)
end

def client
  @client ||= TestClient.new(SERVER_PORT)
end
