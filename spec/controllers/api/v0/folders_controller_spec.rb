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

end
