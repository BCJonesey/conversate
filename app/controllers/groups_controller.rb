class GroupsController < ApplicationController
  before_filter :require_login
  before_filter :require_group_admin, :except => :index
  before_filter :initial_state

  def index
  end

  def edit
    group = Group.find(params[:group])

    group.change_admins(params[:admin])
    @users_not_fully_removed += group.remove_users(params[:remove])

    render :index
  end

  def new_user
    group = Group.find(params[:group])

    user = group.new_user(params[:user])
    unless user
      @error = "There was an error setting up a new user account."
    end

    render :index
  end

  private

  def require_group_admin
    group = Group.find(params[:group])
    unless current_user.group_admin?(group)
      render status: :forbidden
    end
  end

  def initial_state
    @users_not_fully_removed = []
    @error = false
  end
end
