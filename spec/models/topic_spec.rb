require 'spec_helper'

describe Topic do
  before :each do
    @topic = Topic.create name: 'Der Topic'
    @alice = User.build(email: 'alice@example.com', password: 'a')
    @bob = User.build(email: 'bob@example.com', password: 'a')
    @carl = User.build(email: 'carl@example.com', password: 'a')
    @topic.users += [@alice, @bob]
    @convo_abc = Conversation.create title: 'ABC'
    @convo_abc.users += [@alice, @bob, @carl]
    @convo_ab = Conversation.create title: 'AB'
    @convo_ab.users += [@alice, @bob]
    @convo_a = Conversation.create title: 'A'
    @convo_a.users << @alice
    @topic.conversations += [@convo_abc, @convo_ab, @convo_a]
  end

  describe 'adding users' do
    before :each do
      @topic.add_users([@carl], @alice)
    end

    it 'the new users are associated with the topic' do
      @topic.users.include?(@carl).should be_true
    end

    it 'creates an update_viewers action in affected conversations' do
    end
  end

  describe 'removing users' do
    it 'the old users are no longer associated with the topic' do
    end

    it 'create an update_viewers action in affected conversations' do
    end

    it 'puts conversations where that user is participating in their default topic' do
    end
  end
end
