require 'spec_helper'

describe Api::V0::FilesController do
    before(:each) do
        @user = User.create!(:email => 'dummyUser@example.com',
                          :full_name => 'Rufio Pan',
                          :password => 'superDUPERsecretPassword')
        login_user
    end

    let (:upload_file) { [] << fixture_file_upload('/files/scream.jpeg', 'image/jpeg') }

    it 'successfully uploads a new file' do
        conversation = @user.conversations.create!()
        conversation.actions.count.should == 0
        post :create, :conversation => conversation.id, :notes => '', :type => 'upload', :files => upload_file
        expect(response).to be_success
        expect(response.code).to eq("201")
        conversation.actions.count.should == 1
    end

    it 'unsuccessfully uploads a new file to a conversation the user does not have access to' do
        addedUser = User.create!(:email => 'harry@example.com',
                              :full_name => 'Harry Houdini',
                              :password => 'allakhazam')
        conversation = addedUser.conversations.create!()
        conversation.actions.count.should == 0
        post :create, :conversation => conversation.id, :notes => '', :type => 'upload', :files => upload_file
        expect(response).not_to be_success
        expect(response.code).to eq("404")
        conversation.actions.count.should == 0
    end
end
