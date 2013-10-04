class Api::V0::StatusesController < ApplicationController
  before_filter :require_login

  def show
    render :json => {
      global_most_recent_action: current_user.conversations.maximum(:most_recent_action)
    }.to_json
  end
end
