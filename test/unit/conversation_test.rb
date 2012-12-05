require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  test "conversation with no events" do
    assert_equal([], conversations(:no_events).pieces)
  end

  test "conversation with someting?" do
  end
end
