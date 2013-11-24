class UsersController < ApplicationController
  before_filter :require_login, :only => [:edit, :update]
  def edit
    @user = current_user
    @edit_status = nil
  end

  def update
    @user = current_user
    if  User.authenticate @user.email, params[:password]
      if params[:new_password] &&
         params[:new_password] == params[:new_password_confirmation]
        @user.password = params[:new_password]
      end

      if params[:full_name]
        @user.full_name = params[:full_name]
      end

      # One of the ridiculous, tragic flaws of HTML and Rails is that check
      # boxes don't actually use boolean values.
      send_me_mail_checked = !params[:send_me_mail].nil?
      @user.send_me_mail = send_me_mail_checked

      @edit_status = @user.save ? :success : :failure
    else
      @edit_status = :failure
    end
    render :edit
  end
end
