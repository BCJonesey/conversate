class AdminController < ApplicationController
  before_filter :require_site_admin

  def index
  end

  def promote
    signup = BetaSignup.find(params[:id])

    user = signup.create_promoted_user
    if user
      flash[:promotion_status] = :success
      signup.delete
    else
      flash[:promotion_status] = :failure
    end

    UserMailer.activation_needed_email(user).deliver

    redirect_to admin_path
  end
end
