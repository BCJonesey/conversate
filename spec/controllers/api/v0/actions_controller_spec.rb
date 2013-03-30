require "spec_helper"

describe Api::V0::ActionsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    conversation = @user.conversations.create()
    conversation.actions.create(:event_type => :message, :data => '{"text":"After the final no"}')
    conversation.actions.create(:event_type => :retitle, :data => '{"title":"There comes a yes?"}')
  end

  describe 'GET #index' do
    it 'successfully responds with a list of actions for a specified conversation' do
      get :index, :conversation_id => 1
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(1)
      expect(body[0]['type']).to eq('message')
      expect(body[0]['data']).to eq('{"text":"After the final no"}')
      expect(body[0]['id']).to eq(2)
      expect(body[0]['type']).to eq('retitle')
      expect(body[0]['data']).to eq('{"title":"There comes a yes?"}')
    end
    it 'responds unsuccessfully when the conversation does not exist'
  end

  describe 'POST #create' do
    it 'successfully creates a new action in the specified conversation'
  end

end
