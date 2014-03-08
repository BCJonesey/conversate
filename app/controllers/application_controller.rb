class ApplicationController < ActionController::Base
  #protect_from_forgery

  private
  def not_authenticated
    redirect_to root_url
  end

  def require_site_admin
    redirect_to root_url unless current_user.site_admin
  end

  SpeakeasyCode = 'blue spigot'

	def require_login_api
		if !logged_in?
			render :text => "401 Not Logged In", :status => :unauthorized
		end
	end
end
