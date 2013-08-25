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

  def hashify(*models)
    models.map do |m|
      JSON::load(m.to_json(user: @james))
    end
  end

  describe 'adding topics' do
    it 'without creating an action' do
      conversation = Conversation.create!(title: 'Noah and the Whale')
      other_topic = Topic.new(name: 'Five Year Plan')
      other_topic.save
      conversation.add_topics(hashify(@shared, other_topic), @james, false)

      conversation.topics.length.should eq(2)
      conversation.topics.include?(@shared).should be_true
      conversation.topics.include?(other_topic).should be_true
      conversation.actions.empty?.should be_true
    end

    it 'and creating an action' do
      false.should eq true
    end
  end

  describe 'removing topics' do
    it 'without creating an action' do
      false.should eq true
    end

    it 'and creating an action' do
      false.should eq true
    end
  end
end
