class Api::V0::InviteController < ApplicationController

  def create
    invite = Invite.create(:email => params[:email], :user_id => params[:user_id])
    head :status => 500 and return if invite.errors
    render :json => invite, :status => 201
  end

end
