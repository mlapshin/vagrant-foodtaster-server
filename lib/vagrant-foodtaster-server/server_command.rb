require 'drb'
require_relative 'server'

class VagrantFoodtasterServer
  class ServerCommand < Vagrant.plugin(2, :command)
    def execute
      argv = parse_options

      port_number = argv.size == 0 ? 35672 : argv[0].to_i
      DRb.start_service "druby://localhost:#{port_number}", VagrantFoodtasterServer::Server.new(@app, @env)
      DRb.thread.join

    rescue RuntimeError => e
      error = "#{e.message}\n\nServer Error Backtrace:\n  #{e.backtrace.join("\n  ")}"
      @env.ui.error(error)
    rescue Interrupt
      DRb.stop_service
    end
  end
end
