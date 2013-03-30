require "spec_helper"

describe Api::V0::ConversationsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    topic = @user.topics.create(:name => 'The Wobbles')
    topic.conversations.create(:title => 'Wobbly Wobble')
    topic.conversations.create(:title => 'Pretty Damn Solid')
  end

  describe 'GET #index' do
    it "responds successfully with a list of the user's conversations in this topic" do
      get :index, :topic_id => 1
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(1)
      expect(body[0]['title']).to eq('Wobbly Wobble')
      expect(body[1]['id']).to eq(2)
      expect(body[1]['title']).to eq('Pretty Damn Solid')
    end
    it 'responds successfully with the correct timestamp and last message'
    it 'responds successfully with the correct participants'
    it 'responds unsuccessfully when the topic does not exist'
  end

  describe 'GET #show' do
    it 'responds successfully with this conversation' do
      get :show, :id => 1
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(1)
      expect(body['title']).to eq('Wobbly Wobble')
    end
    it 'responds unsuccessfully when the topic does not exist'
  end

  describe 'POST #create' do
    it 'successfully creates a new default conversation in this topic' do
      post :create, :topic_id => 1
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(3)
      expect(body['title']).to eq('New Conversation')
    end
    it 'successfully creates a new conversation in this topic with parameters'
    it 'responds unsuccessfully when the topic does not exist'
  end

end
