class AccountActivationsController < ApplicationController
  skip_before_filter :require_login

  def edit
    @user = User.find_by_activation_token(params[:id])
  end

  def update
    # TODO: Assert that password and confirmation match
    @user = User.find_by_activation_token(params[:id])
    @user.password = params[:password]
    @user.full_name = params[:name]

    if @user.save
      @user.activate!
      login(@user.email, params[:password])
      redirect_to root_url
    else
      flash[:activation_error] = true
      render :edit
    end
  end
end
