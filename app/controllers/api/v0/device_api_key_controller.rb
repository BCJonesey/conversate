class Api::V0::DeviceApiKeyController < ApplicationController
  def create
    candidate_user = User.find_by_email_insensitive(params[:email])
    if candidate_user
      user = login candidate_user.email, params[:password]
    else
      user = nil
    end

    if user
      device = Device.new_device_for(user, params[:description])
      render :json => device
    else
      error = { :status => 401, :error => "Bad username or password" }
      render :json => error, :status => 401
    end
  end
end
