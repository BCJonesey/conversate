class Api::V0::ConversationsController < ApplicationController
  before_filter :require_login_api

  # Note that this is always on a url like /folders/1/conversations.
  def index
    folder = Folder.find_by_id(params[:folder_id])
    head :status => :not_found and return unless folder

    conversations = folder.conversations.includes(:users, :folders, :reading_logs)
    render :json => conversations.to_json(:user => current_user)
  end

  # Note that this is always on a url like /folders/1/conversations.
  def create
    folder = Folder.find_by_id(params[:folder_id])
    head :status => :not_found and return unless folder
    conversation = folder.conversations.create()

    conversation.set_title params[:title] || 'New Conversation', current_user

    # Again, order of ops stuff.  We need participants before we do actions so
    # that we can send emails to external users.
    conversation.add_participants params[:participants], current_user
    conversation.add_actions params[:actions], current_user
    conversation.reload
    conversation.mark_all_unread_for(conversation.users - [current_user])

    # The API technically doesn't specify whether this request should include
    # the user creating the conversation or not, and the client goes back and
    # forth.
    unless conversation.users.include? current_user
      conversation.users << current_user
    end

    conversation.update_most_recent_event
    current_user.update_most_recent_viewed conversation

    conversation.save
    render :json => conversation.to_json(:user => current_user), :status => 201
  end

  def unread_count
    render :json => current_user.unread_count
  end
  def show
    conversation = Conversation.find_by_id(params[:id])
    head :status => :not_found and return unless conversation
    render :json => conversation.to_json(:user => current_user)
  end

end
