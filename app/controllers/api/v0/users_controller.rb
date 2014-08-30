# TODO: This is not up to date, and not currently used by the application.  If
# you write any code against this controller, make sure to bring it up to spec
# with the UsersController in the app.

class Api::V0::UsersController < ApplicationController
  before_filter :require_login_api, :except => [:create]

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
    if !login(current_user.email, params[:password])
      head :unauthorized and return
    end
    user = User.find(params[:id])
    updates = params.slice(:email, :full_name)
    if params[:new_password]
      user.password = params[:new_password]
    end
    if user.update_attributes(updates)
      user.save!
    end
    render :json => user.to_json and return
  end

  def contact_lists
    user = User.find(params[:id])
    render :json => user.contact_lists.as_json
  end

  def look_up
    user = params[:email].nil? ? nil : User.find_by_email(params[:email])
    if user.nil?
      head :status => 404
    else
      render json: user.to_json(for_contact: true)
    end
  end
end
