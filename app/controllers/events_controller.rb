class EventsController < ApplicationController
  def index
    if !!params[:id]
      conversation = Conversation.find(params[:id])
      current_user.mark_as_read(conversation)
      render :json => conversation.pieces.to_json
    else
      render :json => ''
    end
  end
end
