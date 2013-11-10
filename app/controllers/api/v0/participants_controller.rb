class Api::V0::ParticipantsController < ApplicationController
  before_filter :require_login

  # Note that this is always on urls like /conversation/1/participants.
  def index
    conversation = Conversation.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    render :json => conversation.participants.to_json(:conversation => conversation)
  end

  def create
    # Right now this lets any user add any other. At some point we'll want to enforce
    # organizations.
    conversation = Conversation.find_by_id(params[:conversation_id])
    user = User.find_by_id(params[:user_id])
    head :status => 404 and return unless conversation && user
    conversation.users << user

    # Let's add this conversation to the first folder for now.
    folder = Folder.first
    folder.conversations << conversation

    render :json => user.to_json, :status => 201
  end

  def destroy
    # Any user can remove someone from any conversation.
    conversation = Conversation.find_by_id(params[:conversation_id])
    user = User.find_by_id(params[:id])
    head :status => 404 and return unless conversation && user
    conversation.users.delete(user)
    render :json => user.to_json, :status => 204
  end

  # This is actually called when a user wants to update most_recent_viewed. Pretty odd.
  def update
    conversation = Conversation.find_by_id(params[:conversation_id])
    user = User.find_by_id(params[:id])
    head :status => 404 and return unless conversation && user
    log = user.reading_logs.where(:conversation_id => conversation.id).first
    # API sends milliseconds
    if (params[:most_recent_viewed])
      log.most_recent_viewed = DateTime.strptime((params[:most_recent_viewed] / 1000).to_s, "%s")
    end
    log.unread_count = 0
    log.archived = params[:archived] ? params[:archived] : log.archived
    log.save
    render :json => user.to_json, :status => 204
  end
end
