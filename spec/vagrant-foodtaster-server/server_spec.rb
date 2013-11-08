require 'spec_helper'
require 'vagrant-foodtaster-server/server'

describe Vagrant::Foodtaster::Server::Server do
  require_vm :default

  before(:each) do
    default.rollback
  end


  describe 'initialization' do
    it 'should fail if sahara plugin is not installed' do
      res = run_server_on(default)
      res.should_not be_successful
      res.stderr.should =~ /Cannot find `sahara' plugin/
    end
  end

  describe 'runtime' do
    describe '#vm_running?' do
      before(:each) do
        execute_on(default, 'vagrant plugin install sahara')
        run_server_on(default, daemon: true)
      end

      it 'should return true if vm is running' do
        execute_on(default, 'vagrant up')
        client.vm_running?(:default).should be_true
      end
    end
  end
end
