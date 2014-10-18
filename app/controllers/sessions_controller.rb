class SessionsController < ApplicationController
  def create
    # Sorcery uses case-sensitive email for logging in.  This is no good,
    # so we have to hack around.  There doesn't seem to be a Sorcery config
    # for this.

    candidate_user = User.find_by_email_insensitive(params[:email])
    if candidate_user
      user = login candidate_user.email, params[:password], params[:remember_me]
    else
      user = nil
    end

    if user  && !user.removed && !user.external
      redirect_back_or_to root_url
    else
      @login_error = true
      flash[:alert] = "Unable to Sign In"
      redirect_to root_path
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
