require "spec_helper"

describe Api::V0::ActionsController do

  before(:each) do
    @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
    login_user
    @conversation = @user.conversations.create!()
    @a1 = @conversation.actions.create!(:type => 'message',
                                  :data => '{"text":"After the final no"}',
                                  :user_id => @user.id)
    @a2 = @conversation.actions.create!(:type => 'retitle',
                                  :data => '{"title":"There comes a yes?"}',
                                  :user_id => @user.id)
    @a3 = @conversation.actions.create!(:type => 'deletion',
                                  :data => '{"msg_id":1}',
                                  :user_id => @user.id)
    @addedUser = User.create!(:email => 'harry@example.com',
                              :full_name => 'Harry Houdini',
                              :password => 'allakhazam')
    @a4 = @conversation.actions.create!(:type => 'update_users',
                                  :data => '{"added":[{"id":2,"name":"Harry Houdini"}],"removed":[]}',
                                  :user_id => @user.id)
    @a5 = @conversation.actions.create!(:type => 'move_message',
                                  :data => '{"message_id":1,"from":{"title":"Whatever","id":1},"to":{"title":"Wherever","id":2}}',
                                  :user_id => @user.id)
  end

  def timestamp(id)
    action = Action.find(id)
    return action.created_at.msec
  end

  describe 'GET #index' do
    it 'successfully responds with a list of actions for a specified conversation' do

      get :index, :conversation_id => @conversation.id
      expect(response).to be_success
      expect(response.code).to eq("200")
      body = JSON.parse(response.body)

      # Message
      expect(body[0]['id']).to eq(@a1.id)
      expect(body[0]['type']).to eq('message')
      expect(body[0]['text']).to eq('After the final no')
      expect(body[0]['user']['full_name']).to eq('Rufio Pan')
      expect(body[0]['user']['id']).to eq(@user.id)
      expect(body[0]['timestamp']).to eq(timestamp(@a1))

      # Retitle
      expect(body[1]['id']).to eq(@a2.id)
      expect(body[1]['type']).to eq('retitle')
      expect(body[1]['title']).to eq('There comes a yes?')
      expect(body[1]['user']['full_name']).to eq('Rufio Pan')
      expect(body[1]['user']['id']).to eq(@user.id)
      expect(body[1]['timestamp']).to eq(timestamp(@a2.id))

      #Deletion
      expect(body[2]['id']).to eq(@a3.id)
      expect(body[2]['type']).to eq('deletion')
      expect(body[2]['msg_id']).to eq(1)
      expect(body[2]['user']['full_name']).to eq('Rufio Pan')
      expect(body[2]['user']['id']).to eq(@user.id)
      expect(body[2]['timestamp']).to eq(timestamp(@a3.id))

      #Update users
      expect(body[3]['id']).to eq(@a4.id)
      expect(body[3]['type']).to eq('update_users')
      added = Hash.new
      added['id'] = @addedUser.id
      added['name'] = 'Harry Houdini'
      expect(body[3]['added']).to eq([added])
      expect(body[3]['removed']).to eq([])
      expect(body[3]['user']['full_name']).to eq('Rufio Pan')
      expect(body[3]['user']['id']).to eq(@user.id)
      expect(body[3]['timestamp']).to eq(timestamp(@a4.id))

      #Move message
      expect(body[4]['id']).to eq(@a5.id)
      expect(body[4]['type']).to eq('move_message')
      from = {'title' => 'Whatever', 'id' => 1}
      to = {'title' => 'Wherever', 'id' => 2}
      expect(body[4]['from']).to eq(from)
      expect(body[4]['to']).to eq(to)
      expect(body[4]['message_id']).to eq(@a1.id)
      expect(body[4]['user']['full_name']).to eq('Rufio Pan')
      expect(body[4]['user']['id']).to eq(@user.id)
      expect(body[4]['timestamp']).to eq(timestamp(@a5.id))

    end
    it 'responds successfully for each type of action'
    it 'responds unsuccessfully when the conversation does not exist' do
      get :index, :conversation_id => 100
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

  describe 'POST #create' do
    it 'successfully creates a new action in the specified conversation' do
      post :create, :conversation_id => @conversation.id, :type => 'message', :text => 'Hi'
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).not_to eq(@a1.id)
      expect(body['id']).not_to eq(@a2.id)
      expect(body['id']).not_to eq(@a3.id)
      expect(body['id']).not_to eq(@a4.id)
      expect(body['id']).not_to eq(@a5.id)
      expect(body['type']).to eq('message')
      expect(body['text']).to eq('Hi')
      expect(body['user']['full_name']).to eq('Rufio Pan')
      expect(body['user']['id']).to eq(@user.id)
      expect(body['timestamp']).to eq(timestamp(body['id']))
      action = Action.find(body['id'])
      expect(action.text).to eq('Hi')
    end
    it 'successfully retitles a conversation' do
      post :create, :conversation_id => @conversation.id, :type => 'retitle', :title => 'My new title'
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).not_to eq(@a1.id)
      expect(body['id']).not_to eq(@a2.id)
      expect(body['id']).not_to eq(@a3.id)
      expect(body['id']).not_to eq(@a4.id)
      expect(body['id']).not_to eq(@a5.id)
      expect(body['type']).to eq('retitle')
      expect(body['title']).to eq('My new title')
      expect(body['user']['full_name']).to eq('Rufio Pan')
      expect(body['user']['id']).to eq(@user.id)
      expect(body['timestamp']).to eq(timestamp(body['id']))
      conversation = Conversation.find(@conversation.id)
      expect(conversation.title).to eq('My new title')
      action = Action.find(body['id'])
      expect(action.title).to eq('My new title')
    end
    it 'successfully deletes a message' do
      post :create, :conversation_id => @conversation.id, :type => 'deletion', :msg_id => 1
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)
      expect(body['id']).not_to eq(@a1.id)
      expect(body['id']).not_to eq(@a2.id)
      expect(body['id']).not_to eq(@a3.id)
      expect(body['id']).not_to eq(@a4.id)
      expect(body['id']).not_to eq(@a5.id)
      expect(body['type']).to eq('deletion')
      expect(body['msg_id']).to eq('1')
      expect(body['user']['full_name']).to eq('Rufio Pan')
      expect(body['user']['id']).to eq(@user.id)
      expect(body['timestamp']).to eq(timestamp(body['id']))
      action = Action.find(body['id'])
      expect(action.msg_id).to eq('1')
    end
    it 'fails when deleting a non-message action' do
      pending('Deletion is no longer a feature')
      post :create, :conversation_id => @conversation.id, :type => 'deletion', :msg_id => 2
      expect(response).not_to be_success
      expect(response.code).to eq("409")
    end
    it 'successfully updates users'
    it 'successfully moves a message'
    it 'successfully adds to conversation\'s folders' do
      # Merely trying to make a spec for our current behavior.
      roff = Folder.create!(:name => 'Roff')
      boff = Folder.create!(:name => 'Boff')
      @user.folders << boff
      @user.default_folder_id = roff.id
      @user.save
      toff = Folder.create!(:name => 'Toff')

      post :create, :conversation_id => @conversation.id, :type => 'update_folders',
        :added => [{"id" => roff}, {"id" => toff}], :removed => []
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)

      expect(body['id']).not_to eq(@a1.id)
      expect(body['id']).not_to eq(@a2.id)
      expect(body['id']).not_to eq(@a3.id)
      expect(body['id']).not_to eq(@a4.id)
      expect(body['id']).not_to eq(@a5.id)
      expect(body['type']).to eq('update_folders')
      expect(body['added']).to eq([{"id" => "#{roff.id}"}, {"id" => "#{toff.id}"}])
      expect(body['removed']).to eq([])
      expect(body['user']).to eq({"email"=>"dummyUser@example.com",
        "full_name"=>"Rufio Pan", "id"=>@user.id, "site_admin"=>false, "external"=>false})
      expect(body['timestamp']).to eq(timestamp(body['id']))

      conversation = Conversation.find_by_id(@conversation.id)
      expect(conversation.folders.count).to eq(3)
      folder1 = Folder.find_by_id(roff.id)
      folder2 = Folder.find_by_id(toff.id)
      expect(conversation.folders.include?(folder1)).to eq(true)
      expect(conversation.folders.include?(folder2)).to eq(true)
    end
    it 'successfully shows no new viewers when updating a conversation\'s folders' do

      roff = Folder.create!(name: 'Roff')
      @user.folders << roff
      @user.default_folder_id = roff.id
      @user.save
      newf = Folder.create!(:name => 'New folder')

      post :create, :conversation_id => @conversation.id, :type => 'update_folders',
        :added => [{"id" => newf}], :removed => []
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)

      conversation = Conversation.find_by_id(@conversation.id)
      expect(conversation.folders.count).to eq(2)
      expect(body['addedViewers']).to eq([])
    end
    it 'successfully shows one new viewer when updating a conversation\'s folders' do
      roff = Folder.create!(name: 'Roff')
      @user.folders << roff
      @user.default_folder_id = roff.id
      @user.save
      newFolder = Folder.create!(:name => 'New folder')

      user2 = User.create!(:email => 'newUser@example.com',
                              :full_name => 'Bob the Barbary Corsair',
                              :password => 'blackbeard')
      user2.folders << newFolder
      user2.default_folder_id = newFolder.id
      user2.save

      post :create, :conversation_id => @conversation.id, :type => 'update_folders',
        :added => [{"id" => newFolder.id}], :removed => []
      expect(response).to be_success
      expect(response.code).to eq("201")
      body = JSON.parse(response.body)

      expect(body['addedViewers'].length).to eq(1)
      expect(body['addedViewers'][0]['id']).to eq(user2.id)
    end
    it 'responds unsuccessfully when the conversation does not exist' do
      post :create, :conversation_id => 100, :type => 'message', :text => 'Bye'
      expect(response).not_to be_success
      expect(response.code).to eq("404")
    end
  end

end
