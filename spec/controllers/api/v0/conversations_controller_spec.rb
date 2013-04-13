require "spec_helper"

describe Api::V0::ConversationsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    @topic = @user.topics.create(:name => 'The Wobbles')
    @topic.conversations.create(:title => 'Wobbly Wobble')
    @topic.conversations.create(:title => 'Pretty Damn Solid')
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
    it 'responds successfully with the correct most_recent_event' do
      check_most_recent_event = lambda do |mre|
        get :index, :topic_id => 1
        expect(response).to be_success
        expect(response.code).to eq("200")
        body = JSON.parse(response.body)
        expect(body[2]['title']).to eq('Timestamp Convo')
        expect(body[2]['most_recent_event']).to eq(mre)
        expect(body[2]['most_recent_event']).to be_a(Integer)
      end
      conversation = @topic.conversations.create(:title => 'Timestamp Convo')
      conversation.users << @user
      check_most_recent_event[946688839000] # Default value.
      conversation.actions.create!(:event_type => 'message',
                                  :data => '{"text":"You forgot the i, GIII"}',
                                  :user_id => @user.id)
      check_most_recent_event[conversation.most_recent_event.msec]
    end
    it 'responds successfully with the correct most_recent_view'
    it 'responds successfully with the correct participants'
    it 'responds unsuccessfully when the topic does not exist' do
      get :index, :topic_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
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
    it 'responds unsuccessfully when the conversation does not exist' do
      get :show, :id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
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
    it 'responds unsuccessfully when the topic does not exist' do
      post :create, :topic_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

end
