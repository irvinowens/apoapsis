# The queue is as described, jobs that come in for processing will
# end up in the queue.  For now, the queue will just be designed
# as a short-term queue as jobs should be processed quickly
#
# Eventually this will incorporate some sort of distributed
# queuing system

require 'apoapsis/state'

module Apoapsis
  class Queue

    attr_accessor :apo_state

    def initialize
      @apo_state = Apoapsis::State.instance
    end

    def queue_job(json_arg)
      @apo_state.push(Time.now.to_i.to_s,json_arg)
    end

    def get_next_job
      keys=@apo_state.sorted_keys
    end
  end
end