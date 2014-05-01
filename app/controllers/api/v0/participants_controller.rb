class Api::V0::ParticipantsController < ApplicationController
  before_filter :require_login_api

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
    # API sends milliseconds, integer division gets the floor, +1
    # gets the ceiling.  We ceiling so that the action we clicked's timestamp
    # is always less than our most_recent_viewed.
    if (params[:most_recent_viewed])
      most_recent_viewed_in_seconds = (params[:most_recent_viewed] / 1000) + 1
      log.most_recent_viewed = DateTime.strptime(most_recent_viewed_in_seconds.to_s, "%s")
    end
    log.unread_count = 0
    log.archived = params.has_key?(:archived) ? params[:archived] : log.archived
    log.pinned = params.has_key?(:pinned) ? params[:pinned] : log.pinned
    log.save

    # Bust the cache - the user has updated what they've seen.
    Rails.cache.delete("/reading_log/#{user.id}-#{conversation.id}")

    render :json => user.to_json, :status => 204
  end
end
