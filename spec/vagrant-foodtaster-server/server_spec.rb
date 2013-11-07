require 'spec_helper'
require 'vagrant-foodtaster-server/server'

describe Vagrant::Foodtaster::Server::Server do
  require_vm :default

  before(:each) do
    default.rollback
  end

  def execute_on(vm, command)
    vm.execute_as('vagrant', <<-BASH)
      cd #{PROJECT_ROOT}/spec/environment && \
      #{command}
    BASH
  end

  def run_server_on(vm, opts={})
    command = 'vagrant foodtaster-server'
    command << ' &' if opts[:daemon]
    execute_on(vm, command)
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
      end
    end
  end
end
