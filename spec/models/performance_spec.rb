require 'spec_helper'
require 'ruby-prof'

describe Conversation, :performance => true do
  it 'has performance' do
    u = User.all.first
    t = u.topics.first
    t.conversations.to_json(:user => u)
  end
end
