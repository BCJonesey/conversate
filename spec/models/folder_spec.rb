require 'spec_helper'

describe Folder do
  before :each do
    @folder = Folder.create name: 'Der Folder'
    @alice = User.build(email: 'alice@example.com', password: 'a')
    @bob = User.build(email: 'bob@example.com', password: 'a')
    @carl = User.build(email: 'carl@example.com', password: 'a')
    @folder.users += [@alice, @bob]
    @convo_abc = Conversation.create title: 'ABC'
    @convo_abc.users += [@alice, @bob, @carl]
    @convo_abc.actions.create(type: 'retitle', data: '{"title": "ABC"}', user_id: @alice.id)
    @convo_ab = Conversation.create title: 'AB'
    @convo_ab.users += [@alice, @bob]
    @convo_ab.actions.create(type: 'retitle', data: '{"title": "AB"}', user_id: @alice.id)
    @convo_a = Conversation.create title: 'A'
    @convo_a.users << @alice
    @convo_abc.actions.create(type: 'retitle', data: '{"title": "A"}', user_id: @alice.id)
    @folder.conversations += [@convo_abc, @convo_ab, @convo_a]
  end

  describe 'adding users' do
    before :each do
      @folder.add_users([@carl], @alice)
    end

    it 'the new users are associated with the folder' do
      @folder.users.include?(@carl).should be_true
    end

    it 'creates an update_viewers action in affected conversations' do
      @convo_abc.actions.last.type.should_not eq 'update_viewers'
      @convo_ab.actions.last.type.should eq 'update_viewers'
      @convo_ab.actions.last.added.length.should eq 1
      @convo_ab.actions.last.added[0]['id'].should eq @carl.id
      @convo_a.actions.last.type.should eq 'update_viewers'
      @convo_a.actions.last.added.length.should eq 1
      @convo_a.actions.last.added[0]['id'].should eq @carl.id
    end
  end

  describe 'removing users' do
    before :each do
      @folder.remove_users([@bob], @alice)
    end

    it 'the old users are no longer associated with the folder' do
      @folder.users.include?(@bob).should be_false
    end

    it 'create an update_viewers action in affected conversations' do
      @convo_abc.actions.last.type.should_not eq 'update_viewers'
      @convo_ab.actions.last.type.should_not eq 'update_viewers'
      @convo_a.actions.last.type.should eq 'update_viewers'
      @convo_a.actions.last.removed.length.should eq 1
      @convo_a.actions.last.removed[0]['id'].should eq @bob.id
    end

    it 'puts conversations where that user is participating in their default folder' do
      bob_folder = Folder.find(@bob.default_folder_id)
      @convo_abc.folders.include?(bob_folder).should be_true
      @convo_ab.folders.include?(bob_folder).should be_true
      @convo_a.folders.include?(bob_folder).should be_false
    end
  end
end
