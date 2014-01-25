require "spec_helper"

describe Api::V0::ConversationsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    @folder = Folder.create(:name => 'The Wobbles')
    @user.folders << @folder
    @c1 = @folder.conversations.create(:title => 'Wobbly Wobble')
    @c2 = @folder.conversations.create(:title => 'Pretty Damn Solid')
    @user.conversations << @c1
    @user.conversations << @c2
  end

  describe 'GET #index' do
    it "responds successfully with a list of the user's conversations in this folder" do
      get :index, :folder_id => @folder.id
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body[0]['id']).to eq(@c1.id)
      expect(body[0]['title']).to eq('Wobbly Wobble')
      expect(body[1]['id']).to eq(@c2.id)
      expect(body[1]['title']).to eq('Pretty Damn Solid')
    end
    it 'responds successfully with the correct most_recent_event' do
      check_most_recent_event = lambda do |mre|
        get :index, :folder_id => @folder.id
        expect(response).to be_success
        expect(response.code).to eq("200")
        body = JSON.parse(response.body)
        expect(body[2]['title']).to eq('Timestamp Convo')
        expect(body[2]['most_recent_event']).to eq(mre)
        expect(body[2]['most_recent_event']).to be_a(Integer)
      end
      conversation = @folder.conversations.create!(:title => 'Timestamp Convo')
      conversation.users << @user
      check_most_recent_event[946688839000] # Default value.
      conversation.actions.create!(:type => 'message',
                                  :data => '{"text":"You forgot the i, GIII"}',
                                  :user_id => @user.id)
      conversation.update_most_recent_event
      check_most_recent_event[conversation.most_recent_event.msec]
    end
    it 'responds successfully with the correct most_recent_viewed' do
      conversation = Conversation.find_by_id(@c1.id)
      check_most_recent_viewed = lambda do |mve|
        get :index, :folder_id => @folder.id
        expect(response).to be_success
        expect(response.code).to eq("200")
        body = JSON.parse(response.body)
        expect(body[0]['title']).to eq('Wobbly Wobble')
        expect(body[0]['most_recent_viewed']).to eq(mve)
        expect(body[0]['most_recent_viewed']).to be_a(Integer)
      end
      check_most_recent_viewed[946688839000] # Default value.
      conversation.actions.create!(:type => 'message',
                                  :data => '{"text":"You forgot the i, GIII"}',
                                  :user_id => @user.id)
      @user.update_most_recent_viewed(conversation)
      check_most_recent_viewed[conversation.most_recent_viewed_for_user(@user).msec]
    end
    it 'responds successfully with the correct participants' do
      user2 = User.create!(:email => 'someuser@example.com',
                          :full_name => 'Usegi Userio',
                          :password => 'superDUPERsecretPassword')
      user3 = User.create!(:email => 'anotheruser@example.com',
                          :full_name => 'Bob the Builder',
                          :password => 'superDUPERsecretPassword')
      conversation = Conversation.find_by_id(@c1.id)
      conversation.users << user2
      conversation.users << user3
      get :index, :folder_id => @folder.id
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)

      expect(body[0]['participants'][0]['email']).to eq('dummyUser@example.com')
      expect(body[0]['participants'][0]['full_name']).to eq('Rufio Pan')
      expect(body[0]['participants'][1]['email']).to eq('someuser@example.com')
      expect(body[0]['participants'][1]['full_name']).to eq('Usegi Userio')
      expect(body[0]['participants'][2]['email']).to eq('anotheruser@example.com')
      expect(body[0]['participants'][2]['full_name']).to eq('Bob the Builder')
    end
    it 'responds unsuccessfully when the folder does not exist' do
      get :index, :folder_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

  describe 'GET #show' do
    it 'responds successfully with this conversation' do
      get :show, :id => @c1.id
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)
      expect(body['id']).to eq(@c1.id)
      expect(body['title']).to eq('Wobbly Wobble')
    end
    it 'responds unsuccessfully when the conversation does not exist' do
      get :show, :id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

  describe 'POST #create' do
    it 'successfully creates a new default conversation in this folder' do
      post :create, :folder_id => @folder.id
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).not_to eq(@c1.id)
      expect(body['id']).not_to eq(@c2.id)
      expect(body['title']).to eq('New Conversation')
    end
    it 'successfully creates a new conversation in this folder with parameters' do
      user2 = User.create!(:email => 'dummyUser2@example.com',
                          :full_name => 'Huffle Puff',
                          :password => 'superDUPERsecretPassword')
      user2.folders << Folder.find(@folder.id)
      post :create, :folder_id => @folder.id, :title => 'Hufflepuff',
        :participants => [{:id => @user.id,:name => "Rufio Pan"},{:id => user2.id, :name => "Huffle Puff"}],
        :actions => [{:type => "message",:user => {:id => @user.id}, :text => "Hiyoo"}]
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).not_to eq(@c1.id)
      expect(body['id']).not_to eq(@c2.id)
      expect(body['title']).to eq('Hufflepuff')
      conversation = Conversation.find_by_id(body['id'])
      expect(conversation.title).to eq('Hufflepuff')
    end
    it 'has the correct participants and actions'
    it 'responds unsuccessfully when the folder does not exist' do
      post :create, :folder_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

end
