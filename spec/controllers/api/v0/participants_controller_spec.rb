require "spec_helper"

describe Api::V0::ParticipantsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    Topic.create!(:name => 'Herp Derp Topic Werp')
    conversation = @user.conversations.create!()
    conversation.users.create(:email => 'ragnar@example.com',
                                  :full_name => 'Ragnar the Red',
                                  :password => 'somethingLikeAPassword')
    conversation.users.create!(:email => 'hurdleturtle@example.com',
                                  :full_name => 'Hurdle Turtle',
                                  :password => 'runRealFast')
  end

  describe 'GET #index' do
    it 'successfully responds with all of the participants in the current conversation' do
      get :index, :conversation_id => 1
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(1)
      expect(body[0]['full_name']).to eq('Rufio Pan')
      expect(body[0]['email']).to eq('dummyUser@example.com')
      expect(body[1]['id']).to eq(2)
      expect(body[1]['full_name']).to eq('Ragnar the Red')
      expect(body[1]['email']).to eq('ragnar@example.com')
      expect(body[2]['id']).to eq(3)
      expect(body[2]['full_name']).to eq('Hurdle Turtle')
      expect(body[2]['email']).to eq('hurdleturtle@example.com')
    end
    it 'successfully responds with the correct last_updated_time'
    it 'unsuccessfully responds when the conversation does not exist' do
      get :index, :conversation_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

  describe 'POST #create' do
    it 'successfully creates a participants in a specified conversation' do
      conversation = Conversation.find_by_id(1)
      user = User.create!(:email => 'added@example.com',
                          :full_name => 'Added by Example',
                          :password => 'gobbledegook')
      post :create, :conversation_id => 1, :user_id => user.id
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(4)
      expect(body['full_name']).to eq('Added by Example')
      expect(body['email']).to eq('added@example.com')
    end
    it 'successfully creates a participant with the correct last_updated_time'
    it 'adds the participant to the conversation and puts it into the correct topic for that user'
    it 'unsuccessfully creates when the conversation does not exist' do
      post :create, :conversation_id => 100, :user_id => 1
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
    it 'unsuccessfully creates when the user does not exist' do
      post :create, :conversation_id => 1, :user_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

  describe 'DELETE #destroy' do
    it 'successfully removes a specified participant from a specified conversation' do
      delete :destroy, :conversation_id => 1, :id => 3
      expect(response).to be_success
      expect(response.code).to eq("204")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(3)
      expect(body['full_name']).to eq('Hurdle Turtle')
      expect(body['email']).to eq('hurdleturtle@example.com')
      conversation = Conversation.find_by_id(1)
      expect(conversation.participants.count).to eq(2)
    end
    it 'unsuccessfully removes a participant when the conversation does not exist' do
      delete :destroy, :conversation_id => 100, :id => 3
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
    it 'unsuccessfully removes a participant when the participant does not exist.' do
      delete :destroy, :conversation_id => 1, :id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end
end
