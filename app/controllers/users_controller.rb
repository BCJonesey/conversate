class UsersController < ApplicationController
  before_filter :require_login, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.build params[:user]
    if @user
      login @user.email, params[:user][:password], false
      redirect_to root_url
    else
      render :new
    end
  end

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

      @edit_status = @user.save ? :success : :failure
    else
      @edit_error = :failure
    end
    render :edit
  end
end
