class Api::V0::ConversationsController < ApplicationController
  before_filter :require_login

  # Note that this is always on a url like /topics/1/conversations.
  def index
    topic = Topic.find_by_id(params[:topic_id])
    head :status => :not_found and return unless topic

    conversations = topic.conversations
    render :json => conversations.to_json(:user => current_user)
  end

  # Note that this is always on a url like /topics/1/conversations.
  def create
    topic = Topic.find_by_id(params[:topic_id])
    head :status => :not_found and return unless topic
    conversation = topic.conversations.create()

    conversation.set_title params[:title] || 'New Conversation', current_user

    conversation.users << current_user
    conversation.add_participants params[:participants], current_user

    conversation.add_actions params[:actions], current_user

    conversation.update_most_recent_event
    current_user.update_most_recent_viewed conversation

    conversation.save
    render :json => conversation.to_json(:user => current_user), :status => 201
  end

  def show
    conversation = Conversation.find_by_id(params[:id])
    head :status => :not_found and return unless conversation
    render :json => conversation.to_json(:user => current_user)
  end

end
