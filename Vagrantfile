$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require File.dirname(__FILE__) + '/lib/vagrant-foodtaster-server'
PROJECT_ROOT = '/tmp/vagrant-foodtaster-server'

Vagrant.configure("2") do |config|
  config.vm.box = "precise"
  config.vm.box_url = "http://redmine.hospital-systems.com/vagrant-boxes/ubuntu1204.box"
  config.vm.synced_folder File.dirname(__FILE__), PROJECT_ROOT, owner: 'vagrant', group: 'vagrant'

  #vagrant_package = 'vagrant_1.3.5_x86_64.deb'
  vagrant_package = 'vagrant_1.3.5_i686.deb'
  config.vm.provision :shell,
    inline: "wget http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/#{vagrant_package} && dpkg -i #{vagrant_package} && rm #{vagrant_package}"

  virtualbox_package = 'vbox.deb'
  config.vm.provision :shell,
    inline: "echo 'deb http://download.virtualbox.org/virtualbox/debian precise contrib' >> /etc/apt/source.list"
  config.vm.provision :shell,
    inline: "apt-get update && apt-get install -y virtualbox"

end
