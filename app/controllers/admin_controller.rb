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
      UserMailer.activation_needed_email(user).deliver
    else
      flash[:promotion_status] = :failure
    end

    redirect_to admin_path
  end

  def remove_from_beta
    signup = BetaSignup.find(params[:id])
    signup.delete
    redirect_to admin_path
  end
end
