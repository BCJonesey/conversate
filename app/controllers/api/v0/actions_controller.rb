class Api::V0::ActionsController < ApplicationController

  def index
    conversation = current_user.conversations.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    render :json => conversation.actions.to_json
  end

  def create
  end

end
