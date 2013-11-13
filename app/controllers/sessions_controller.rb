class SessionsController < ApplicationController
  def create
    user = login params[:email], params[:password], params[:remember_me]
    if user
      redirect_back_or_to root_url 
    else
      @login_error = true
      flash[:alert] = "Failed to match e-mail/password"
      redirect_to root_path
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
