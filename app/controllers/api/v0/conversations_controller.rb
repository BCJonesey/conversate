class Api::V0::ConversationsController < ApplicationController
  before_filter :require_login

  # Note that this is always on a url like /topics/1/conversations.
  def index
    topic = Topic.find_by_id(params[:topic_id])
    head :status => :not_found and return unless topic
    render :json => current_user.conversations.where(:topic_id => topic.id).to_json(:user => current_user)
  end

  # Note that this is always on a url like /topics/1/conversations.
  def create
    topic = Topic.find_by_id(params[:topic_id])
    head :status => :not_found and return unless topic
    conversation = topic.conversations.create()
    if (params[:title])
      conversation.title = params[:title]
    end
    conversation.users << current_user
    if (params[:participants])
      params[:participants].each do |p|
        user = User.find(p[:id])
        conversation.users << user
      end
    end
    conversation.save
    render :json => conversation.to_json(:user => current_user), :status => 201
  end

  def show
    conversation = Conversation.find_by_id(params[:id])
    head :status => :not_found and return unless conversation
    render :json => conversation.to_json(:user => current_user)
  end

end
