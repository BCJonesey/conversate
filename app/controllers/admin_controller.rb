class AdminController < ApplicationController
  before_filter :require_admin

  def index
  end

  private
  def require_admin
    redirect_to root_url unless current_user.is_admin
  end
end
