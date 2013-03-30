class Api::V0::UsersController < ApplicationController
  before_filter :require_login, :except => [:create]

  # This is going to be kind of weird in that it shows data about the current_user
  # rather than all users.
  def index
    render :json => current_user.to_json
  end

  def create
    user = User.create!(:email => params[:email],
                        :full_name => params[:full_name],
                        :password => params[:password])
    render :json => user, :status => 201
  end

  def update
    if (current_user.password != params['old_password'])
      head :unauthorized
    end
  end

end
