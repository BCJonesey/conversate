class Api::V0::FilesController < ApplicationController
  before_filter :require_login_api

  def create
  	upload_file = params[:files][0]
  	file = Upload.create!(:upload => upload_file)
    url = file.upload.url
    file_name = file.upload_file_name

    # We need to stick in an action just to show this upload.
    # TODO: Check that this conversation is actually accessible by the current user.
    conversation = Conversation.find_by_id(params[:conversation])
    action = conversation.actions.new(:type => 'upload_message',
                                  :data => '{"fileUrl":"' + url + '","notes":"' + params[:notes] + '","fileName":"' + file_name + '"}',
                                  :user_id => current_user.id)

    action.save
    conversation.handle(action)

    render :json => {}
  end

end
