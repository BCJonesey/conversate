class Api::V0::TopicsController < ApplicationController
  before_filter :require_login

  def index
    render :json => Topic.all.to_json(:user => current_user)
  end

  def create
    topic = current_user.topics.create(:name => params[:name])
    render :json => topic.to_json(:user => current_user), :status => 201
  end

end
