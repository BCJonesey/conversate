class InviteController < ApplicationController

  def create
    invite = Invite.create(params)
  end

end
