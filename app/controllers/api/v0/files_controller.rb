class Api::V0::FilesController < ApplicationController
  before_filter :require_login_api

  def create
  	upload_file = params[:files][0]
  	file = Upload.new(:upload => upload_file)
    file.save
    url = file.upload.url

	conversation = Conversation.find_by_id(112)
    action = conversation.actions.new(:type => 'message',
                                  :data => '{"text":"' + url + '"}',
                                  :user_id => current_user.id)

    action.save
    conversation.handle(action)

    render :json => {}
  end

end
