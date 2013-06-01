class Api::V0::ActionsController < ApplicationController
  before_filter :require_login

  # Note that this will always be on urls like /conversations/1/actions.
  def index
    conversation = current_user.conversations.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    render :json => conversation.actions.to_json
  end

  # Note that this will always be on urls like /conversations/1/actions.
  def create
    conversation = current_user.conversations.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    action = conversation.actions.new(:type => params[:type],
                                          :data => Action::data_for_params(params),
                                          :user_id => current_user.id)
    if (action.type == 'deletion')
      deleted = Action.find(action.msg_id)
      head :status => 409 and return unless (deleted.type == 'message')
    end

    conversation.handle(action)
    action.save
    conversation.update_most_recent_event
    render :json => action.to_json, :status => 201
  end

end
