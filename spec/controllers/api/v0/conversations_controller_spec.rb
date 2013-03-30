require "spec_helper"

describe Api::V0::ConversationsController do

  describe 'GET #index' do
    it "responds successfully with a list of the user's conversations in this topic" do
      get :index
    end
  end

  describe 'GET #show' do
    it 'responds successfully with this conversation'
  end

  describe 'POST #create' do
    it 'successfully creates a new conversation in this topic'
  end

end
