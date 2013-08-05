require 'spec_helper'

describe Conversation do
  before :each do
    @james = User.build(email: 'james@example.com', password: 'a')
    @sally = User.build(email: 'sally@example.com', password: 'a')
    @steve = User.build(email: 'steve@example.com', password: 'a')

    @shared = Topic.create!(name: 'Shared')
    @james.topics << @shared
    @sally.topics << @shared
  end

  describe 'creation' do
    it 'adds the conversation to a participant\'s default topic if necessary' do
      conversation = Conversation.create!(title: 'Hey everyone')

      conversation.topics << @shared
      conversation.users << @james

      expect(conversation.topics.length).to eq(1)
      expect(conversation.topics.first).to eq(@shared)

      conversation.add_participants([{id: @steve.id}], @james)

      expect(conversation.topics.length).to eq(2)
      expect(conversation.topics[1].id).to eq(@steve.default_topic_id)

      conversation.add_participants([{id: @sally.id}], @james)

      expect(conversation.topics.length).to eq(2)
    end
  end

  describe 'adding participants later' do
    it 'adds the conversation to a participant\'s default topic if necessary' do
      conversation = Conversation.create!(title: 'Buzzards')
      conversation.topics << @shared
      conversation.users << @james

      expect(conversation.topics.length).to eq(1)
      expect(conversation.topics.first).to eq(@shared)

      conversation.handle(conversation.actions.new(type: 'update_users',
                                                   data: {added: [{id: @steve.id}],
                                                          removed: []}.to_json,
                                                   user_id: @james.id))

      expect(conversation.topics.length).to eq(2)
      expect(conversation.topics[1].id).to eq(@steve.default_topic_id)

      conversation.handle(conversation.actions.new(type: 'update_users',
                                                   data: {added: [{id: @sally.id}],
                                                          removed: []}.to_json,
                                                   user_id: @james.id))

      expect(conversation.topics.length).to eq(2)
    end
  end
end
