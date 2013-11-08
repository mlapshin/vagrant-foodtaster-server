module Vagrant
  module Foodtaster
    module Server
      class Plugin < Vagrant.plugin("2")
        name "Foodtaster Server"

        command 'foodtaster-server' do
          require_relative 'server_command'
          ServerCommand
        end
      end
    end
  end
end
