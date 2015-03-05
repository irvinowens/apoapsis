require 'minitest/autorun'
require_relative '../lib/apoapsis'

class StateTest < Minitest::Test
  def setup
    @state= Apoapsis::State.instance
  end

  def teardown
  end

  # Will test adding an entry to the state object

  def test_add_get_entry
    @state.push(key: 'test', value: { :ballin_hard => 'true',
                                      :city => 'Atlanta'})
    assert_equal(@state.get(key:'test')[:ballin_hard],'true')
  end

  def test_thread_add_get_entry
    t1=Thread.new {
      @state.push(key: 'test', value: { :ballin_hard => 'true',
                                        :city => 'Atlanta'})
    }
    t2=Thread.new {
      sleep 0.5
      @state.push(key: 'test', value: { :ballin_hard => 'true',
                                        :city => 'Philadelphia'})
    }
    t1.join
    t2.join
    assert_equal('Philadelphia',@state.get(key:'test')[:city])
  end

  def test_same_process_update
    @state.push(key: 'test', value: { :ballin_hard => 'true',
                                      :city => 'Atlanta'})
    @state.push(key: 'test', value: { :ballin_hard => 'true',
                                      :city => 'Philadelphia'})
    assert_equal('Philadelphia',@state.get(key:'test')[:city])
  end
end