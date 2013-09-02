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

  def update
    topic = Topic.find(params[:id])
    if topic.update_attributes(params[:topic])
        format.json { head :ok }
    else
      format.json { render json: topic.errors, status: :unprocessable_entity }
    end
  end
  def update_users
    topic = Topic.find(params[:id])
    topic.add_users(params[:added].map { |e|  User.find(e[:id])},current_user)
    topic.remove_users(params[:removed].map { |e|  User.find(e[:id])},current_user)
    format.json { head :ok }
  end
end
