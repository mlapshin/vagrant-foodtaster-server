require 'spec_helper'
require 'vagrant-foodtaster-server/server'

require 'tempfile'
require 'tmpdir'

describe Vagrant::Foodtaster::Server::Server do
  before(:each) do
    start_server
  end

  after(:each) do
    stop_server
  end

  before(:each) do
    execute('bundle exec vagrant halt -f')
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
    client.vm_ip(:default).should == SERVER_IP
  end

  it 'should check if vm defined' do
    client.vm_defined?(:default).should be_true
    client.vm_defined?(:magic).should_not be_true
  end

  it 'should put and get files' do
    Tempfile.open('recipe') do |recipe|
      client.put_file_to_vm(:default, recipe.path, 'recipe')
    end

    Dir.mktmpdir do |dir|
      client.get_file_from_vm(:default, 'recipe', dir + '/recipe')
      File.exist?(dir + '/recipe').should be_true
    end
  end

  it 'should execute command on vm' do
    result =
      client.execute_command_on_vm(:default, 'echo Hello, Foodtaster!')
    result[:stdout].should == "Hello, Foodtaster!\n"
    result[:exit_status].should == 0
  end

  it 'should make initial snapshot on vm' do
    client.make_initial_snapshot_on_vm(:default)
    client.initial_snapshot_made_on_vm?(:default).should be_true
  end

  it 'should run chef in vm' do
    run_config = {
      run_list: ['test::chef_test_recipe'],
      json: {}
    }
    client.run_chef_on_vm(:default, run_config)
    result = client.execute_command_on_vm(:default, 'cat /tmp/hello')
    result[:stdout].should == "Hello, Foodtaster!"
  end
end
