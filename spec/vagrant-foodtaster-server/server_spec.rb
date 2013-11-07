require 'spec_helper'
require 'vagrant-foodtaster-server/server'

describe Vagrant::Foodtaster::Server::Server do
  require_vm :default

  before(:each) do
    default.rollback
  end

  it 'should fail if sahara plugin is not installed' do
    res = default.execute <<-BASH
      su vagrant -c  \
      'cd #{PROJECT_ROOT}/spec/environment && \
      vagrant foodtaster-server'
    BASH
    res.should_not be_successful
    res.stderr.should =~ /Cannot find `sahara' plugin/
  end
end
