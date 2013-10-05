require 'spec_helper'

describe Conversation do
  before :each do
    @james = User.build(email: 'james@example.com', password: 'a')
    @sally = User.build(email: 'sally@example.com', password: 'a')
    @steve = User.build(email: 'steve@example.com', password: 'a')

    @shared = Folder.create!(name: 'Shared')
    @james.folders << @shared
    @sally.folders << @shared
  end

  describe 'creation' do
    it 'adds the conversation to a participant\'s default folder if necessary' do
      conversation = Conversation.create!(title: 'Hey everyone')

      conversation.folders << @shared
      conversation.users << @james

      expect(conversation.folders.length).to eq(1)
      expect(conversation.folders.first).to eq(@shared)

      conversation.add_participants([{id: @steve.id}], @james)

      expect(conversation.folders.length).to eq(2)
      expect(conversation.folders[1].id).to eq(@steve.default_folder_id)

      conversation.add_participants([{id: @sally.id}], @james)

      expect(conversation.folders.length).to eq(2)
    end
  end

  describe 'adding participants later' do
    it 'adds the conversation to a participant\'s default folder if necessary' do
      conversation = Conversation.create!(title: 'Buzzards')
      conversation.folders << @shared
      conversation.users << @james

      expect(conversation.folders.length).to eq(1)
      expect(conversation.folders.first).to eq(@shared)

      conversation.handle(conversation.actions.new(type: 'update_users',
                                                   data: {added: [{id: @steve.id}],
                                                          removed: []}.to_json,
                                                   user_id: @james.id))

      expect(conversation.folders.length).to eq(2)
      expect(conversation.folders[1].id).to eq(@steve.default_folder_id)

      conversation.handle(conversation.actions.new(type: 'update_users',
                                                   data: {added: [{id: @sally.id}],
                                                          removed: []}.to_json,
                                                   user_id: @james.id))

      expect(conversation.folders.length).to eq(2)
    end
  end

  def hashify(*models)
    models.map do |m|
      JSON::load(m.to_json(user: @james))
    end
  end

  describe 'adding folders' do
    it 'without creating an action' do
      conversation = Conversation.create!(title: 'Noah and the Whale')
      other_folder = Folder.new(name: 'Five Year Plan')
      other_folder.save
      conversation.add_folders(hashify(@shared, other_folder), @james, false)

      conversation.folders.length.should eq(2)
      conversation.folders.include?(@shared).should be_true
      conversation.folders.include?(other_folder).should be_true
      conversation.actions.empty?.should be_true
    end

    it 'and creating an action' do
      conversation = Conversation.create!(title: 'Noah and the Whale')
      other_folder = Folder.new(name: 'Five Year Plan')
      other_folder.save
      conversation.add_folders(hashify(@shared, other_folder), @james)

      conversation.folders.length.should eq(2)
      conversation.folders.include?(@shared).should be_true
      conversation.folders.include?(other_folder).should be_true
      conversation.actions.length.should eq(1)
      conversation.actions.first.type.should eq('update_folders')
      conversation.actions.first.added.length.should eq(2)
      conversation.actions.first.added[0]['id'].should eq(@shared.id)
      conversation.actions.first.added[1]['id'].should eq(other_folder.id)
    end
  end

  describe 'removing folders' do
    it 'without creating an action' do
      conversation = Conversation.create(title: 'Zoe Keating')
      folder_one = Folder.create(name: 'Code')
      folder_two = Folder.create(name: 'x16')
      conversation.folders += [@shared, folder_one, folder_two]
      conversation.remove_folders(hashify(@shared, folder_one), @james, false)

      conversation.folders.length.should eq(1)
      conversation.folders.include?(folder_two).should be_true
      conversation.actions.empty?.should be_true
    end

    it 'and creating an action' do
      conversation = Conversation.create(title: 'Zoe Keating')
      folder_one = Folder.create(name: 'Code')
      folder_two = Folder.create(name: 'x16')
      conversation.folders += [@shared, folder_one, folder_two]
      conversation.remove_folders(hashify(@shared, folder_one), @james)

      conversation.folders.length.should eq(1)
      conversation.folders.include?(folder_two).should be_true
      conversation.actions.length.should eq(1)
      conversation.actions.first.type.should eq('update_folders')
      conversation.actions.first.removed.length.should eq(2)
      conversation.actions.first.removed[0]['id'].should eq(@shared.id)
      conversation.actions.first.removed[1]['id'].should eq(folder_one.id)
    end

    it 'puts the conversation in the default folder of orphaned users' do
      conversation = Conversation.create(title: 'Tom Morello')
      conversation.folders << @shared
      conversation.users << @james
      conversation.save

      conversation.folders.length.should eq(1)
      conversation.folders.include?(@shared).should be_true

      conversation.remove_folders([{id: @shared.id}], @james)

      conversation.folders.length.should eq(1)
      conversation.folders.include?(@james.default_folder).should be_true
      conversation.actions.last.type.should eq('update_folders')
      conversation.actions.last.added.length.should eq(1)
      conversation.actions.last.added[0]['id'].should eq(@james.default_folder.id)
      conversation.actions.last.removed.length.should eq(1)
      conversation.actions.last.removed[0]['id'].should eq(@shared.id)
    end
  end
end
