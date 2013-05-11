require "spec_helper"

describe Api::V0::ActionsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    conversation = @user.conversations.create!()
    conversation.actions.create!(:type => 'message',
                                  :data => '{"text":"After the final no"}',
                                  :user_id => @user.id)
    conversation.actions.create!(:type => 'retitle',
                                  :data => '{"title":"There comes a yes?"}',
                                  :user_id => @user.id)
  end

  describe 'GET #index' do
    it 'successfully responds with a list of actions for a specified conversation' do
      get :index, :conversation_id => 1
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(1)
      expect(body[0]['type']).to eq('message')
      expect(body[0]['text']).to eq('After the final no')
      expect(body[0]['user']['name']).to eq('Rufio Pan')
      expect(body[0]['user'][id]).to eq(1)
      expect(body[1]['id']).to eq(2)
      expect(body[1]['type']).to eq('retitle')
      expect(body[1]['title']).to eq('There comes a yes?')
      expect(body[0]['user']['name']).to eq('Rufio Pan')
      expect(body[0]['user'][id]).to eq(1)
    end
    it 'responds successfully for each type of action'
    it 'responds unsuccessfully when the conversation does not exist' do
      get :index, :conversation_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

  describe 'POST #create' do
    it 'successfully creates a new action in the specified conversation' do
      post :create, :conversation_id => 1, :type => 'message', :text => 'Hi'
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(3)
      expect(body['type']).to eq('message')
      expect(body['text']).to eq('Hi')
    end
    it 'responds successfully for each type of action'
    it 'responds unsuccessfully when the conversation does not exist' do
      post :create, :conversation_id => 100, :type => 'message', :text => 'Bye'
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

end
