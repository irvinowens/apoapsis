require 'minitest/autorun'
require_relative '../lib/apoapsis'

class SystemTest < Minitest::Test
  def setup
    @state= Apoapsis::State.instance
    Apoapsis::Network.startup
  end

  def teardown
  end

  def test_load_average
    la=Apoapsis::System.get_load_average
    assert(la['5m'])
  end
end