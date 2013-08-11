require 'drb'
require_relative 'server'

class VagrantFoodtasterServer
  class ServerCommand < Vagrant.plugin(2, :command)
    def execute
      ui = @env.ui
      argv = parse_options

      port_number = argv.size == 0 ? 8787 : argv[0].to_i
      DRb.start_service "druby://localhost:#{port_number}", VagrantFoodtasterServer::Server.new(@app, @env)
      ui.info "Started Foodtaster Server at druby://localhost:#{port_number}"
      ui.info "Press Ctrl+C to stop."

      begin
        DRb.thread.join
      rescue Interrupt
        DRb.stop_service
      end
    end
  end
end
