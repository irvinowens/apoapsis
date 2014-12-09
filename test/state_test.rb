require 'minitest/autorun'
require 'apoapsis/state'

class StateTest < Minitest::Test
  def setup
    @state= State.instance
  end

  # Will test adding an entry to the state object

  def test_add_get_entry
    @state.push(key: 'test', value: { :ballin_hard => 'true',
                                      :city => 'Atlanta'})
    assert_equal(@state.get(key:'test')[:ballin_hard],'true')
  end

  def test_thread_add_get_entry
    Thread.new {
      @state.push(key: 'test', value: { :ballin_hard => 'true',
                                        :city => 'Atlanta'})
    }
    Thread.new {
      @state.push(key: 'test', value: { :ballin_hard => 'true',
                                        :city => 'Fooillmatic'})
    }
    assert_equal(@state.get(key:'test')[:city],'Foolillmatic')
  end
end