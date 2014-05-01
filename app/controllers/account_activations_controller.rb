class AccountActivationsController < ApplicationController
  skip_before_filter :require_login

  def edit
    @user = User.find_by_activation_token(params[:id])
  end

  def update
  end
end
