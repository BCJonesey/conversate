class GroupsController < ApplicationController
  before_filter :require_login
  before_filter :require_group_admin, :except => :index

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

    render :index
  end

  private

  def require_group_admin
    group = Group.find(params[:group])
    unless current_user.group_admin?(group)
      render status: :forbidden
    end
  end
end
