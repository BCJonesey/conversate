class Api::V0::ParticipantsController < ApplicationController
  before_filter :require_login

  # Note that this is always on urls like /conversation/1/participants.
  def index
    conversation = Conversation.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    render :json => conversation.participants(current_user).to_json
  end

  def create
    # Right now this lets any user add any other. At some point we'll want to enforce
    # organizations.
    conversation = Conversation.find_by_id(params[:conversation_id])
    user = User.find_by_id(params[:user_id])
    head :status => 404 and return unless conversation && user
    conversation.users << user
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

end
