class HomeController < ApplicationController
  def index
    if logged_in?
      folder = current_user.folders.first
      if folder
        redirect_to folder_path(folder.slug, folder.id) and return
      else
        @folders = Folder.all
        @conversation = nil
        @conversations = []
        @actions = nil
        @participants = nil

        render 'structural/show' and return
      end
    end
    render layout: "application_rails"
  end

  def beta_signup
    signup = BetaSignup.new(email: params[:email])
    success = signup.save
    flash[:signed_up] = success

    if success
      BetaSignupMailer.beta_signup_email(beta_signup).deliver
    end

    render :index, layout: 'application_rails'
  end
end
