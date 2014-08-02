class UsersController < ApplicationController
  before_filter :require_login, :only => [:edit, :update]
  def edit
    @user = current_user
    @edit_status = nil
  end

  def update
    @user = current_user
    if params[:new_password]
      if User.authenticate(@user.email, params[:password]) &&
         params[:new_password] == params[:new_password_confirmation]
         @user.password = params[:new_password]
         @edit_status = @user.save ? :success : :failure
      else
        @edit_status = :failure
      end
    elsif params[:full_name]
      @user.full_name = params[:full_name]
      @edit_status = @user.save ? :success : :failure
    elsif params[:email_settings_form]
      send_me_mail_checked = !params[:send_me_mail].nil?
      @user.send_me_mail = send_me_mail_checked
      @edit_status = @user.save ? :success : :failure
    end

    render :edit
  end

end
