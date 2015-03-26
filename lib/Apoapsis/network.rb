# The network class will handle all inbound socket communications whether for
# state coordination or distributed processing

require 'eventmachine'
require 'logger'
require 'queue'
require 'singleton'

module Apoapsis
  # The sync module will handle messages coming in for this server with the
  # intent of keeping the global execution state current

  module Sync
    # Handle inbound data messages

    def receive_data(data)
      # Handle inbound state store sync
      # queue the work for the running thread
      Apoapsis::Queue.instance.queue_job(JSON.parse(data))
      Apoapsis.log.debug "Queued job : #{data}"
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
      end
    end
    def connect(server: nil, port: nil, mod: nil)
      EventMachine::connect server, port, mod
    end

    def connect_sync(server: nil, port: nil)
      connect(server: server, port: port, module:Apoapsis::Sync)
    end
  end

  # The network class will facilitate communication across machines

  class Network
    include Singleton

    attr_accessor :sync

      def startup

        # Start up the sync listener

        @sync=Thread.new{
            EventMachine::run do
              host = '0.0.0.0'
              port = 6169

              EventMachine::start_server host, port, Sync
            end
          }
        Thread.join(@sync)
      end

      def shutdown
        EventMachine::stop_event_loop
      end
    end
end