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
    device_api_key = request.headers['X-Watercooler-Device-Api-Key']
    device_key = device_api_key ? Device.find_by_device_api_key(device_api_key) : nil
    auto_login(device_key.user) unless device_key.nil?
  end
end
