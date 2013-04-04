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

    end
    it 'unsuccessfully responds when the conversation does not exist'
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
