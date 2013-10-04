class Api::V0::StatusesController < ApplicationController
  before_filter :require_login

  def show
    render :json => current_user.status.to_json
  end
end
