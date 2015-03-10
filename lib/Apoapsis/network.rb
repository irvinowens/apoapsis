# The network class will handle all inbound socket communications whether for
# state coordination or distributed processing

require 'eventmachine'
require 'logger'
require 'singleton'

module Apoapsis
  # The sync module will handle messages coming in for this server with the
  # intent of keeping the global execution state current

  module Sync
    # Handle inbound data messages

    def receive_data(data)
      # Handle inbound state store sync
    end
  end

  # The execute module will receive content related to running a process with
  # the intent to return a job id to the caller, process the task and call back
  # with the job id and the result

  module Execute
    def receive_data(data)
      # Queue and perform an inbound execution task
    end
  end

  # The Apoapsis client, will connect to a list of server peers for distributed
  # processing, if all forked processes are busy

  module Client
    attr_accessor :server_list

    def initialize(servers: [])
      !servers.empty? || raise(ArgumentError, 'You have to provide servers')
      @server_list=servers
      servers.each do |server|
        connect_sync server:server[:addr], port: server[:port]
        connect_execute server:server[:addr], port: server[:port]
      end
    end
    def connect(server: nil, port: nil, mod: nil)
      EventMachine::connect server, port, mod
    end

    def connect_execute(server: nil, port: nil)
      connect(server: server, port: port, module:Apoapsis::Execute)
    end

    def connect_sync(server: nil, port: nil)
      connect(server: server, port: port, module:Apoapsis::Sync)
    end
  end

  # The network class will facilitate communication across machines

  class Network
    include Singleton

    attr_accessor :sync, :execute

      def startup

        # Start up the sync listener

        @sync=Thread.new{
            EventMachine::run do
              host = '0.0.0.0'
              port = 6169

              EventMachine::start_server host, port, Sync
            end
          }

        # start up the execution listener

        @execute=Thread.new{
          EventMachine::run do
            host = '0.0.0.0'
            port = 6170

            EventMachine::start_server host, port, Execute
          end
        }
        Thread.join(@execute)
        Thread.join(@sync)
      end

      def shutdown
        EventMachine::stop_event_loop
      end
    end
end