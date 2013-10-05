class Api::V0::StatusesController < ApplicationController
  before_filter :require_login

  def show
    status = {}
    if current_user.conversations.length > 0
      status[:global_most_recent_action] =
        current_user.conversations.maximum(:most_recent_action).msec
    end
    render :json => status.to_json
  end
end
