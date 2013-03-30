class Api::V0::TopicsController < ApplicationController
  before_filter :require_login

  def index
    render :json => current_user.topics.to_json
  end

  def create
  end

end
