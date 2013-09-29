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
    it "successfully returns folders with correct unread counts" do
      check_unread_count = lambda do |count|
        get :index
        expect(response).to be_success
        expect(response.code).to eq("200")
        body = JSON.parse(response.body)
        expect(body[0]['unread_conversations']).to eq count
      end
      check_unread_count[0]
      folder = Folder.find_by_id(1)
      conversation = folder.conversations.create(:title => 'A conversation')
      @user.conversations << conversation
      conversation.actions.create!(:type => 'message',
                                    :data => '{"text":"Just a random message."}',
                                    :user_id => 2)
      # We have to make sure all our models and things get fresh data from the
      # database instead of keeping cached values around.
      @user.reload

      check_unread_count[1]
      @user.update_most_recent_viewed(conversation)
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
      expect(body['unread_conversations']).to eq 0
    end
  end

  describe 'DELETE #delete' do
    it "successfully deletes the specified folder" do
      expect(Folder.find_by_id(1)).to be_true
      delete :delete, :id => 1
      expect(Folder.find_by_id(1)).to be_nil
    end
  end

end
