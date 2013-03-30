class Api::V0::ConversationsController < ApplicationController

  # Note that this is always on a url like /topics/1/conversations.
  def index
    topic = current_user.topics.find(params[:topic_id])
    render :json => topic.conversations.to_json
  end

  def create
    topic = current_user.topics.find(params[:topic_id])
    conversation = topic.conversations.create()
    render :json => conversation
  end

  def show
    conversation = Conversation.find(params[:id])
    render :json => conversation.to_json
  end

end
