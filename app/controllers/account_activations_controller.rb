class AccountActivationsController < ApplicationController
  skip_before_filter :require_login

  def edit
    @user = User.find_by_activation_token(params[:id])
  end

  def update
    @user = User.find_by_activation_token(params[:id])

    unless params[:password] == params[:password_confirmation]
      flash[:activation_error] = :password_mismatch
      render :edit and return
    end

    @user.password = params[:password]
    @user.full_name = params[:name]

    if @user.save
      @user.create_welcome_conversation
      @user.activate!
      login(@user.email, params[:password])
      redirect_to root_url
    else
      flash[:activation_error] = :unknown_error
      render :edit
    end

    UserMailer.activation_success_email(@user).deliver
  end
end
