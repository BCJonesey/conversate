require "spec_helper"

describe Api::V0::UsersController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body['email']).to eq('dummyUser@example.com')
      expect(body['full_name']).to eq('Rufio Pan')
      expect(body['id']).to eq(1)
    end
    it "has a correct address book"
  end

  describe 'POST #create' do
    it "responds successfully with the created user" do
      post :create,
        :email => 'examplio@example.com',
        :full_name => "Examplio D'Examparelli",
        :password => "ZePassword"
      expect(response).to be_success
      expect(response.code).to eq('201')
      body = JSON.parse(response.body)
      expect(body['email']).to eq('examplio@example.com')
      expect(body['full_name']).to eq("Examplio D'Examparelli")
      expect(body['id']).to eq(2) # We've created a user already in the before filter.
    end
  end

end
