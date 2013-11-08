require 'drb'
require_relative 'server'

module Vagrant
  module Foodtaster
    module Server
      class ServerCommand < Vagrant.plugin(2, :command)
        def execute
          argv = parse_options

          arg = argv.first
          if arg && arg.include?(':')
            host, port = arg.split(':')
          else
            port = arg
          end
          host ||= 'localhost'
          port ||= 35672
          DRb.start_service "druby://#{host}:#{port}", Vagrant::Foodtaster::Server::Server.new(@app, @env)
          DRb.thread.join

        rescue RuntimeError, Errno::EADDRINUSE => e
          write_formatted_exception_message(e)
          exit 1
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
