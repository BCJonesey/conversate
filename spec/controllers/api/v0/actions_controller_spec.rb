require "spec_helper"

describe Api::V0::ActionsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    conversation = @user.conversations.create()
    conversation.actions.create(:type => :message, :text => 'After the final no')
    conversation.actions.create(:type => :retitle, :title => 'There comes a yes?')
  end

  describe 'GET #index' do
    it 'successfully responds with a list of actions for a specified conversation'
    it 'responds unsuccessfully when the conversation does not exist'
  end

  describe 'POST #create' do
    it 'successfully creates a new action in the specified conversation'
  end

end
