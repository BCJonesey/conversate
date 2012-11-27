class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def not_authenticated
    redirect_to new_session_url
  end
end
