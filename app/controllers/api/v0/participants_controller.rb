class Api::V0::ParticipantsController < ApplicationController

  def index
    conversation = Conversation.find(params[:conversation_id])
    render :json => conversation.participants(current_user).to_json
  end

  def create
  end

  def destroy
  end

end
