require 'drb/drb'
require_relative 'server'

class VagrantFoodtasterServer
  class ServerCommand < Vagrant.plugin(2, :command)
    def execute
      ui = @env.ui
      argv = parse_options
      port_number = argv.size == 0 ? 8787 : argv[0].to_i

      ui.info "Starting Foodtaster Server at druby://localhost:#{port_number}"
      DRb.start_service "druby://localhost:#{port_number}", VagrantFoodtasterServer::Server.new(@app, @env)
      DRb.thread.join
    end
  end
end
