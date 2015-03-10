# The queue is as described, jobs that come in for processing will
# end up in the queue.  For now, the queue will just be designed
# as a short-term queue as jobs should be processed quickly
#
# Eventually this will incorporate some sort of distributed
# queuing system

require 'state'

module Apoapsis
  class Queue

    attr_accessor :apo_state

    def initialize
      @apo_state = Apoapsis::State.instance
    end

    def queue_block(&block)
      @apo_state
    end
  end
end