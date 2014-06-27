class Api::V0::InviteController < ApplicationController

  def create
    invite = Invite.create(:email => params[:email], :user_id => params[:user_id])
    head :status => 500 and return if invite.errors.count > 0
    render :json => invite, :status => 201

    UserMailer.send_invite(invite.email).deliver
  end

end
