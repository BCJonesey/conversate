require 'spec_helper'

describe Api::V0::StatusesController do
  describe 'GET #show' do
    before :each do
      @user = User.build(email: 'user@example.com',
                         password: 'a')
      login_user
      @conversation_one = Conversation.create!(title: 'One')
      @conversation_two = Conversation.create!(title: 'Two')
      @user.conversations += [@conversation_one, @conversation_two]
      @user.save
    end

    it 'shows the current timestamp' do
      get :show
      expect(response).to be_success
      body = JSON.parse(response.body)
      expect(body['global_most_recent_action']).to eq(946688839000)
    end

    it 'shows the latest timestamp' do
      now = Time.now.msec
      @conversation_one.update_most_recent_action

      get :show
      body = JSON.parse(response.body)
      expect(body['global_most_recent_action'] >= now).to be_true
    end
  end
end
