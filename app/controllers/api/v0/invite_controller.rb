class Api::V0::InviteController < ApplicationController
  before_filter :require_login

  def create
    invite = Invite.create(:email => params[:email], :user_id => current_user.id)
    head :status => 500 and return if invite.errors.count > 0
    render :json => invite, :status => 201

    UserMailer.send_invite(invite.email).deliver

    # If we've successfully sent an email, we want to remove one of the user's invites.
    current_user.invite_count -= 1
  end

end
