class Api::V0::InviteController < ApplicationController

  def create
    invite = Invite.create(params)
  end

end
