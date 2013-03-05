class EventsController < ApplicationController
  def index
    if !!params[:id]
      conversation = Conversation.find(params[:id])
      current_user.mark_as_read(conversation)

    if stale?(:last_modified => conversation.updated_at.utc, :etag => conversation)
      render :json => conversation.pieces.to_json
    end

    else
      render :json => ''
    end
  end

  def create
    if !!params[:conversation_id]
      conversation = Conversation.find(params[:conversation_id])

      message_event = Event.new({:conversation_id => conversation.id,
                                 :user_id => current_user.id,
                                 :event_type => 'message',
                                 :data => {:message_id => conversation.next_message_id,
                                           :text => params[:text]}.to_json})
      message_event.save
      current_user.mark_as_read(conversation)
      render :json => message_event.to_json

      conversation.update_most_recent_event
    else
      render :json => ''
    end
  end

end
