class Api::V0::ParticipantsConcernController < ApplicationController
  before_filter :require_login_api

  def index
    @subject = ContactList.find(params[:contact_list_id])
    render :json => @subject.participants
  end

end
