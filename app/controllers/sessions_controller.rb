class SessionsController < ApplicationController
  def new
    @login_error = false
  end

  def create
    user = login params[:email], params[:password], params[:remember_me]
    if user
      redirect_back_or_to conversations_url
    else
      @login_error = true
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
