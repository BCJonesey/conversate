class Api::V0::ActionsController < ApplicationController
  before_filter :require_login

  # Note that this will always be on urls like /conversations/1/participants.
  def index
    conversation = current_user.conversations.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    render :json => conversation.actions.to_json
  end

  # Note that this will always be on urls like /conversations/1/participants.
  def create
    conversation = current_user.conversations.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    action = conversation.actions.create!(:event_type => params[:event_type],
                                          :data => params[:data],
                                          :user_id => current_user.id)
    conversation.update_most_recent_event
    render :json => action.to_json, :status => 201
  end

end
