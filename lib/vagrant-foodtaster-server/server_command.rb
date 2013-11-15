require 'drb'
require_relative 'server'

module Vagrant
  module Foodtaster
    module Server
      class ServerCommand < Vagrant.plugin(2, :command)
        def execute
          argv = parse_options

          host, port = parse_args(argv.first)
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

        def parse_args(args)
          host, port = if args && args.include?(':')
                         args.split(':')
                       else
                          [nil, args]
                       end
          host ||= 'localhost'
          port ||= 35672
          [host, port]
        end
      end
    end
  end
end
