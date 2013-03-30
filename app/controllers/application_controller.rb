class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def not_authenticated
    redirect_to new_session_url
  end

  def require_admin
    redirect_to root_url unless current_user.is_admin
  end
end
