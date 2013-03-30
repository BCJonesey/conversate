class Api::V0::ConversationsController < ApplicationController

  def index
    topic = current_user.topics.find(params[:topic_id])
    render :json => topic.conversations.to_json
  end

  def create
  end

  def show
  end

end
