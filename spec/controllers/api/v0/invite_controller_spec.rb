require 'spec_helper'

describe Api::V0::InviteController do

  context "create" do

    it "should be able to make an invite" do
      post :create, :email => 'bob@example.com', :user_id => 1
      expect(response).to be_success
      expect(response.code).to eq('201')
      body = JSON.parse(response.body)
      expect(body['email']).to eq('bob@example.com')
      expect(body['user_id']).to eq(1)
    end

  end

end
