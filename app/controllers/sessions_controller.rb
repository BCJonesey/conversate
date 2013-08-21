class SessionsController < ApplicationController
  def new
    @login_error = false
  end

  def create
    if User.find_by_email(params[:email]).removed
      @login_error = true
      render :new and return
    end

    user = login params[:email], params[:password], params[:remember_me]
    if user
      redirect_back_or_to root_url
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
