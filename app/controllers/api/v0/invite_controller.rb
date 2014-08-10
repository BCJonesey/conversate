class Api::V0::InviteController < ApplicationController
  before_filter :require_login

  def create

    invite = Invite.build({inviter: current_user, invitee_email: params[:email]})

    render :json => invite.errors, :status => 500 and return if invite.errors.count > 0

    render :json => invite, :status => 201
  end

end
