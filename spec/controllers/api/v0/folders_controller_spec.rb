require "spec_helper"

describe Api::V0::FoldersController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    tt = Folder.create(:name => 'Terror Time')
    p = Folder.create(:name => 'Plebians')
    @user.folders << tt
    @user.folders << p
  end

  describe 'GET #index' do
    it "successfully returns a list of all folders" do
      get :index
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(1)
      expect(body[0]['name']).to eq('Terror Time')
      expect(body[1]['id']).to eq(2)
      expect(body[1]['name']).to eq('Plebians')
    end
    it "successfully returns folders with correct default unread counts" do
      check_unread_count = lambda do |count|
        get :index
        expect(response).to be_success
        expect(response.code).to eq("200")
        body = JSON.parse(response.body)
        puts body[0]['unread_conversations']
        expect(body[0]['unread_conversations'].length).to eq count
      end
      check_unread_count[0]
    end
  end

  describe 'POST #create' do
    it "successfully creates a new folder" do
      post :create, :name => 'Huzzah!'
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(3)
      expect(body['name']).to eq('Huzzah!')
      expect(body['unread_conversations'].length).to eq 0
    end
  end

  describe 'DELETE #delete', :t => true do
    it "successfully deletes the specified folder" do
      expect(Folder.find_by_id(1)).to be_true
      delete :destroy, :id => 1
      expect(response).to be_success
      expect(response.code).to eq("204")
      expect(Folder.find_by_id(1)).to be_nil
    end
    it "cannot delete a user's default folder" do
      @user.default_folder_id = Folder.create!(:name => 'Unsinkable Folder').id
      @user.save
      expect(User.find_by_id(1).default_folder_id).to eq(3)

      expect(Folder.find_by_id(3)).to be_true
      delete :destroy, :id => 3
      expect(response).not_to be_success
      expect(response.code).to eq("409")
      expect(Folder.find_by_id(3)).to be_true
    end
    it "moves orphaned conversations for each participant to their default folder" do
      orphanUser = User.create!(:email => 'heehee@example.com',
                          :full_name => 'Captain Hee-hee',
                          :password => 'superDUPERsecretPassword')
      orphanUser.default_folder_id = Folder.create!(:name => 'Safety Folder').id
      orphanUser.save
      expect(User.find_by_id(2).default_folder_id).to eq(3)
      expect(Folder.find_by_id(3)).to be_true

      deadFolder = Folder.create!(:name => 'The Walking Dead')
      expect(Folder.find_by_id(4)).to be_true
      conversation = deadFolder.conversations.create(:title => 'Gonna Move')
      expect(Conversation.find_by_id(1)).to be_true
      expect(conversation.folders.find_by_id(4)).to be_true
      expect(conversation.folders.find_by_id(1)).not_to be_true

      delete :destroy, :id => 4
      expect(response).to be_success
      expect(response.code).to eq("204")
      expect(Folder.find_by_id(4)).not_to be_true
      expect(conversation.folders.find_by_id(4)).not_to be_true
      expect(conversation.folders.find_by_id(1)).to be_true
    end
  end

end
