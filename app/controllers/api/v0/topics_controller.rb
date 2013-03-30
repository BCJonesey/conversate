class Api::V0::TopicsController < ApplicationController
  before_filter :require_login

  def index
    render :json => current_user.topics.to_json
  end

  def create
    topic = current_user.topics.create(:name => params[:name])
    render :json => topic.to_json, :status => 201
  end

end
