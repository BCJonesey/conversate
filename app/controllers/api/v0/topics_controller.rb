class Api::V0::TopicsController < ApplicationController
  before_filter :require_login

  def index
    render :json => current_user.topics.to_json(:user => current_user)
  end

  def create
    topic = Topic.create(:name => params[:name])
    current_user.topics << topic
    current_user.save
    render :json => topic.to_json(:user => current_user), :status => 201
  end
end
