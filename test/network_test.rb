require 'minitest/autorun'
require_relative '../lib/apoapsis'

class NetworkTest < Minitest::Test
  def setup
    @state= Apoapsis::State.instance
    @network=Apoapsis::Network.instance
    @network.startup
  end

  def teardown
    @network.shutdown
    @state=nil
    @network=nil
  end
end