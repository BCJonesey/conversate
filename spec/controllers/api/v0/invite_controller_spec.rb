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
      @user.invite_count = 10
      post :create, :email => 'bob@example.com'
      expect(response).to be_success
      expect(response.code).to eq('201')
      body = JSON.parse(response.body)
      expect(body['email']).to eq('bob@example.com')
      expect(body['user_id']).to eq(@user.id)
      expect(Invite.count).to eq(1)
    end

    it "should remove one invite from a user on success" do
      @user.invite_count = 10
      expect(@user.invite_count).to eq 10
      post :create, :email => 'bob@example.com'
      expect(@user.invite_count).to eq 9
      expect(Invite.count).to eq(1)
    end

    it "should not remove one invite from a user on not actually sending an email" do
      @user.invite_count = 10
      expect(@user.invite_count).to eq 10
      post :create, :email => 'bob'
      expect(response).not_to be_success
      expect(response.code).to eq('500')
      expect(@user.invite_count).to eq 10
      expect(Invite.count).to eq(0)
    end

    it "should not send an invite from a user who has none left" do
      @user.invite_count = 0
      post :create, :email => 'bob@example.com'
      expect(response).not_to be_success
      expect(response.code).to eq('500')
      expect(@user.invite_count).to eq 0
      expect(Invite.count).to eq(0)
    end

    it "should create a user for the invite" do
      @user.invite_count = 1
      user_count = User.count
      post :create, :email => 'bob@example.com'
      expect(User.count).to eq user_count + 1
    end

  end

end
