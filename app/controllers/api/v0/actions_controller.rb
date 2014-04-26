class Api::V0::ActionsController < ApplicationController
  before_filter :require_login_api

  # Note that this will always be on urls like /conversations/1/actions.
  def index
    # TODO: Make require_participation generic enough to be on this and both
    # conversation controllers.
    conversation = Conversation.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    json = Rails.cache.fetch("/conversation/#{conversation.id}-#{conversation.updated_at}/actions") do
      conversation.actions.reverse.to_json
    end
    render :json => json
  end

  # Note that this will always be on urls like /conversations/1/actions.
  def create
    conversation = Conversation.find_by_id(params[:conversation_id])
    head :status => 404 and return unless (conversation && conversation.can_user_update?(current_user))

    action = conversation.actions.new(:type => params[:type],
                                      :data => Action::data_for_params(params),
                                      :user_id => current_user.id)

    # We need to know our current set before applying an update folders.
    if (action.type == 'update_folders')
      # This will eventually make its way to when we calculate what json we need for update_folders.
      params['prior_conversation_users_and_participants'] = conversation.viewers_and_participants()
    end

    # Unfortunately, there's some important order-of-operations stateful stuff
    # here.  We need to save the action before handling it - in the case of
    # message actions that need emails sent, the email queue runs off the action
    # id.
    action.save
    conversation.handle(action)

    # Now we can actually calculate our real data for our update_folders.
    if (action.type == 'update_folders')
      action.update_data(params)
    end

    conversation.update_most_recent_event
    render :json => action.to_json, :status => 201
  end
end
