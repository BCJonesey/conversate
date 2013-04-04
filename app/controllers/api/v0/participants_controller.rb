class Api::V0::ParticipantsController < ApplicationController

  def index
    conversation = Conversation.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    render :json => conversation.participants(current_user).to_json
  end

  def create
  end

  def destroy
  end

end
