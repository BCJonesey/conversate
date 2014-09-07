class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def not_authenticated
    redirect_to root_url
  end

  def require_site_admin
    redirect_to root_url unless current_user.site_admin
  end

  def require_login_api
    try_device_login unless logged_in?
		if !logged_in?
			render :text => "401 Not Logged In", :status => :unauthorized
		end
	end

  def try_device_login
    @current_user = request.headers["X-Watercooler-User"] ? User.find(request.headers["X-Watercooler-User"]) : nil
  end
end
