require 'apoapsis/version'
require 'apoapsis/state'
require 'apoapsis/network'
require 'apoapsis/distributable'
require 'apoapsis/system'
require 'fileutils'
require 'singleton'
require 'fiber'

module Apoapsis
  include Distributable
  include State
  include System
  include Singleton
  include Network
  # The workers
  attr_accessor :wolfpack, :work_thread
  # Log setup
  FileUtils.mkpath '/var/log/apoapsis/' unless File.exists?('/var/log/apoapsis')
  FileUtils.touch('/var/log/apoapsis/apoapsis.log') unless File.exists?('/var/log/apoapsis/apoapsis.log')
  @@logger=Logger.new('/var/log/apoapsis/apoapsis.log',10,1024000)
  @@logger.level=Logger::DEBUG
  # get the apoapsis logger
  def self.log
    @@logger
  end

  def initialize
    @wolfpack=[]
  end

  # The startup method will be invoked if either a distributable starts, or
  # the startup method is called directly.
  # Calling this method if the system is already running will do nothing
  # if it isn't running it will start the socket listeners connecting
  # to the other systems, then it will start up the worker processes
  # finally the job loop will start running

  def startup
    # 1. Start processes
    Apoapsis.log.info 'Listeners started.'
    Apoapsis.log.info 'Starting workers...'
    65536.times.each do
      @wolfpack << Fiber.new{
        Apoapsis.instance.run
        Fiber.yield
      }
      Apoapsis.log.info "Started worker with process id #{@wolfpack.last}"
    end
    Apoapsis.log.info "#{@wolfpack.length } workers running"
    # 2. TODO: Start listeners once the basic processing system is done
    Apoapsis.log.info 'Starting listeners...'
    Network.instance.startup
    Apoapsis.log.info 'Listeners started...'
    # 3. Start handling tasks
    @work_thread=Thread.new{
      loop do
        Signal.trap('HUP'){
          puts 'Quitting work!'
          exit
        }
        @wolfpack.each do |fiber|
          fiber.resume
        end
        sleep(0.2)
      end
    }
    Apoapsis.log.info 'Apoapsis ready...'
    @work_thread.join
  end

  # The processing loop
  # Will pull the last job off the queue, removing it and then start working
  # on it.  If it fails, the job is gone

  def run
    keys=State.instance.sorted_keys
    if keys.length > 0
      job=State.instance.get keys.last
      State.instance.remove keys.last
      job.execute
    end
    sleep 0.2
  end
end
