require "spec_helper"

describe Api::V0::TopicsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    @user.topics.create(:name => 'Terror Time')
    @user.topics.create(:name => 'Plebians')
  end

  describe 'GET #index' do
    it "successfully returns a list of all of the user's topics" do
      get :index
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(1)
      expect(body[0]['name']).to eq('Terror Time')
      expect(body[1]['id']).to eq(2)
      expect(body[1]['name']).to eq('Plebians')
    end
    it "successfully returns topics with correct unread counts" do
      check_unread_count = lambda do |count|
        get :index
        expect(response).to be_success
        expect(response.code).to eq("200")
        body = JSON.parse(response.body)
        expect(body[0]['unread_conversations']).to eq count
      end
      check_unread_count[0]
      topic = Topic.find_by_id(1)
      conversation = topic.conversations.create(:title => 'A conversation')
      @user.conversations << conversation
      conversation.actions.create!(:event_type => 'message',
                                    :data => '{"text":"Just a random message."}',
                                    :user_id => 2)
      check_unread_count[1]
      @user.mark_as_read(conversation)
      check_unread_count[0]
    end
  end

  describe 'POST #create' do
    it "successfully creates a new topic" do
      post :create, :name => 'Huzzah!'
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(3)
      expect(body['name']).to eq('Huzzah!')
      expect(body['unread_conversations']).to eq 0
    end
  end

end
