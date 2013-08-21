class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def not_authenticated
    redirect_to new_session_url
  end

  def require_site_admin
    redirect_to root_url unless current_user.site_admin
  end
end
