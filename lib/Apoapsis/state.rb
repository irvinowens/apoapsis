# The State object is a memory store for the state map in given classes
# each child class, supervisors, workers, etc, will have to store any state
# that should be persisted across the system
#
# This class is a singleton as it needs to coordinate update transactions
# across systems, and as such it's external methods are thread safe

require 'singleton'

module Apoapsis
  class State
    include Singleton

    # The global state object, and the semaphore can be used elsewhere, but they
    # shouldn't.  The use case I have in mind is if someone really wants to
    # manipulate the global_state from outside, but they don't want to violate
    # consistency they can wait on the semaphore

    attr_reader :semaphore

    attr_reader :global_state

    # We want to set up our map so that it can be used, maybe we will want to
    # have some sort of passivization tech behind our hash so it is easy to
    # recover from a catastrophic crash, but we can deal with that later if it
    # become necessary.
    #
    # The state object should not need to read the configuration file directly
    # it should always be able to call into a wrapper module for the config

    def initialize
      @global_state = {}
      @semaphore= Mutex.new
    end

    # The internal actions of reading and writing state will be wrapped in this
    # transaction, it will take a block and said block of code will only be
    # executed in sequence

    def transaction &block
      semaphore.synchronize{
        block.call
      }
    end

    # External easy method for adding something to the global state table.
    # I was thinking about making state versioned, while that would make the
    # framework faster because I could avoid tracking references, it would add
    # complexity for dubious gain.
    #
    # Combinations of state changes should be chained from inside the
    # transaction method and passed as a block.  This method will return the
    # previous value given for that key

    def push(scope: 'default', key: nil, value: nil)
      key || raise(ArgumentError, 'A key must be provided')
      original_value = nil
      transaction {
        original_value=@global_state[scope + '-' + key]
      }
      transaction {
        @global_state[scope + '-' + key] = value
      }
      return original_value
    end

    # Will fetch an instance of state, use this method first to obtain state,
    # modify it, and replace it.  As other

    def get(scope: 'default', key: nil)
      key || raise(ArgumentError, 'A key must be provided')
      result= nil
      transaction {
        result= @global_state[scope + '-' + key]
      }
      return result
    end

  end
end
