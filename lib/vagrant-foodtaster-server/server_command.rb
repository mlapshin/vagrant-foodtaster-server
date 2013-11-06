require 'drb'
require_relative 'server'

module Vagrant
module Foodtaster
module Server
  class ServerCommand < Vagrant.plugin(2, :command)
    def execute
      argv = parse_options

      port_number = argv.size == 0 ? 35672 : argv[0].to_i
      DRb.start_service "druby://localhost:#{port_number}", Vagrant::Foodtaster::Server::Server.new(@app, @env)
      DRb.thread.join

    rescue RuntimeError, Errno::EADDRINUSE => e
      write_formatted_exception_message(e)
    rescue Interrupt
      DRb.stop_service
    end

    private

    def write_formatted_exception_message(e)
      error = "#{e.message}\n\nServer Error Backtrace:\n  #{e.backtrace.join("\n  ")}"
      @env.ui.error(error)
    end
  end
end
end
end
