require 'spec_helper'
require 'vagrant-foodtaster-server/server'

describe Vagrant::Foodtaster::Server::Server do
  before(:each) do
    start_server
  end

  after(:each) do
    stop_server
  end

  before(:each) do
    execute('vagrant halt -f')
    client.start_vm(:default)
  end

  it 'should start vm' do
    client.vm_running?(:default).should be_true
  end

  it 'should shutdown started vm' do
    client.shutdown_vm(:default)
    client.vm_running?(:default).should_not be_true
  end

  it 'should return ip for vm' do
    #client.vm_ip(:default).should == SERVER_IP
  end
end
