class HomeController < ApplicationController
  def index
    if logged_in?
      folder = current_user.folders.first
      if folder
        redirect_to folder_path(folder.slug, folder.id) and return
      else
        @folder = nil
        @folders = []
        @conversation = nil
        @conversations = []
        @actions = nil
        @participants = nil

        render 'structural/show' and return
      end
    end

    @referrer = params[:refer] ? params[:refer] : request.referrer
    render layout: "application_rails"
  end

  def beta_signup

    unless BetaSignup.find_by_email(:email => params[:email])
      signup = BetaSignup.new(email: params[:email], referrer: params[:referrer])
      success = signup.save
      flash[:signed_up] = success
    else
      # We could make another flash message, but then that sort of leaks that their email
      # address is a thing. At least this way they'll think it went through again if they
      # had a browser problem and we won't spam them or get duped in the database.
      flash[:signed_up] = true
    end

    if success
      BetaSignupMailer.beta_signup_email(signup).deliver
    end

    render :index, layout: 'application_rails'
  end
end
