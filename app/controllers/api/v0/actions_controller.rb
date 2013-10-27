class Api::V0::ActionsController < ApplicationController
  before_filter :require_login

  # Note that this will always be on urls like /conversations/1/actions.
  def index
    # TODO: Make require_participation generic enough to be on this and both
    # conversation controllers.
    conversation = Conversation.find_by_id(params[:conversation_id])
    head :status => 404 and return unless conversation
    render :json => conversation.actions.to_json
  end

  # Note that this will always be on urls like /conversations/1/actions.
  def create
    conversation = Conversation.find_by_id(params[:conversation_id])
    head :status => 404 and return unless (conversation && conversation.can_user_update?(current_user))

    action = conversation.actions.new(:type => params[:type],
                                      :data => Action::data_for_params(params),
                                      :user_id => current_user.id)

    # We need to update the reading_log.unread_counts for each user except for the action creator.
    conversation.users.each do |user|
      unless (user == current_user)
        reading_log = ReadingLog.where(:user_id => user.id, :conversation_id => conversation.id).first
        reading_log.unread_count += 1
        reading_log.save
      end
    end

    # We need to know our current set before applying an update folders.
    if (action.type == 'update_folders')
      # This will eventually make its way to when we calculate what json we need for update_folders.
      params['prior_conversation_users_and_participants'] = conversation.viewers_and_participants()
    end

    conversation.handle(action)

    # Now we can actually calculate our real data for our update_folders.
    if (action.type == 'update_folders')
      action.data = Action::data_for_params(params)
    end

    if (action.type == 'deletion')
      deleted = Action.find(action.msg_id)
      head :status => 409 and return unless (deleted.type == 'message')
    end

    action.save
    conversation.update_most_recent_event
    render :json => action.to_json, :status => 201
  end
end
