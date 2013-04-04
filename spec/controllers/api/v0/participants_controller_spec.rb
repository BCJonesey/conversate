require "spec_helper"

describe Api::V0::ParticipantsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
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
      expect(body[0]['id']).to eq(2)
      expect(body[0]['full_name']).to eq('Ragnar the Red')
      expect(body[0]['email']).to eq('ragnar@example.com')
      expect(body[1]['id']).to eq(3)
      expect(body[1]['full_name']).to eq('Hurdle Turtle')
      expect(body[1]['email']).to eq('hurdleturtle@example.com')
    end
    it 'successfully responds with the correct last_updated_time'
    it 'unsuccessfully responds when the conversation does not exist' do
      get :index, :conversation_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

  describe 'POST #create' do
    it 'successfully creates a participants in a specified conversation'
    it 'unsuccessfully creates when the conversation does not exist'
  end

  describe 'DELETE #destroy' do
    it 'successfully removes a specified participant from a specified conversation'
    it 'unsuccessfully removes a participant when the conversation does not exist'
    it 'unsuccessfully removes a participant when the participant does not exist.'
  end
end
