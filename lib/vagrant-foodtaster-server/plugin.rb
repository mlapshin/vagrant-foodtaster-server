class VagrantFoodtasterServer < Vagrant.plugin("2")
  name "Foodtaster Server"

  command 'foodtaster-server' do
    require_relative 'server_command'
    VagrantFoodtasterServer::ServerCommand
  end
end
