class Api::V0::FilesController < ApplicationController
  before_filter :require_login_api

  def create
  	upload_file = params[:files][0]
  	file = Upload.new(:upload => upload_file)
    file.save
    url = file.upload.url

    # We need to stick in an action just to show this upload.
    # TODO: Check that this conversation is actually accessible by the current user.
    conversation = Conversation.find_by_id(params[:conversation])
    action = conversation.actions.new(:type => 'upload_message',
                                  :data => '{"text":"' + url + '"}',
                                  :user_id => current_user.id)

    action.save
    conversation.handle(action)

    render :json => {}
  end

end
