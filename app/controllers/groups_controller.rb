class GroupsController < ApplicationController
  before_filter :require_login
  before_filter :require_group_admin, :except => :index
  before_filter :initial_state

  def index
  end

  def edit
    group = Group.find(params[:group])

    params[:admin].each do |id|
      user = User.find(id.to_i)
      unless user.group_admin?(group)
        gp = GroupParticipation.where(user_id: user.id, group_id: group.id).first
        gp.group_admin = true
        gp.save
      end
    end

    group.admins.each do |admin|
      unless params[:admin].include? admin.id.to_s
        gp = GroupParticipation.where(user_id: admin.id, group_id: group.id).first
        gp.group_admin = false
        gp.save
      end
    end

    params[:remove].each do |id|
      user = User.find(id.to_i)

      if user.groups.length == 1
        user.removed = true
        user.topics.each do |topic|
          topic.users.delete user
          topic.save
        end
        user.conversations.each do |conversation|
          conversation.users.delete user
          conversation.save
        end
      else
        @removed_users_with_more_groups << user
      end

      user.groups.delete group
      user.save
    end

    render :index
  end

  def new_user
    group = Group.find(params[:group])

    user = User.build(params[:user])
    if user
      user.groups << group
      user.save
    else
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
    @removed_users_with_more_groups = []
    @error = false
  end
end
