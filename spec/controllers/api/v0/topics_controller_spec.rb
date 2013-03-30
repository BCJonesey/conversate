require "spec_helper"

describe Api::V0::TopicsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    @user.topics.create(:name => 'Terror Time')
    @user.topics.create(:name => 'Plebians')
  end

  describe 'GET #index' do
    it "successfully returns a list of all of the user's topics" do
      get :index
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(1)
      expect(body[0]['name']).to eq('Terror Time')
      expect(body[1]['id']).to eq(2)
      expect(body[1]['name']).to eq('Plebians')
    end
    it "successfully returns topics with correct unread counts"
  end

end
