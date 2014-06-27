require 'spec_helper'

describe Api::V0::InviteController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword',
                          :invite_count => 10)
    login_user
  end

  context "create" do

    it "should be able to make an invite" do
      post :create, :email => 'bob@example.com'
      expect(response).to be_success
      expect(response.code).to eq('201')
      body = JSON.parse(response.body)
      expect(body['email']).to eq('bob@example.com')
      expect(body['user_id']).to eq(1)
    end

    it "should remove one invite from a user on success" do
      @user.invite_count = 10
      expect(@user.invite_count).to eq 10
      post :create, :email => 'bob@example.com'
      expect(@user.invite_count).to eq 9
    end

  end

end
