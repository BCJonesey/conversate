class Api::V0::InviteController < ApplicationController
  before_filter :require_login

  def create

    # Users must have invites left.
    head :status => 500 and return unless current_user.invite_count > 0

    # Let's create our invite.
    invite = Invite.create(:email => params[:email], :user_id => current_user.id)
    head :status => 500 and return if invite.errors.count > 0

    # Let's try to send the email.
    begin
      UserMailer.send_invite(invite.email).deliver
    rescue Exception
      head :status => 500 and return
    end

    # If we've successfully sent an email, we want to remove one of the user's invites.
    current_user.invite_count -= 1

    render :json => invite, :status => 201
  end

end
