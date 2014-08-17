class Api::V0::ContactsController < ApplicationController
  before_filter :require_login_api

  # Note that this will always be on urls like /contact_lists/1/contacts.
  def index
    # TODO: Make require_participation generic enough to be on this and both
    # conversation controllers.
    contact_list = ContactList.find_by_id(params[:contact_list_id])
    head :status => 404 and return unless contact_list
    render :json => contact_list.contacts.to_json
  end

  # Note that this will always be on urls like /contact_lists/1/contacts.
  def create
    contact_list = ContactList.find_by_id(params[:contact_list_id])
    head :status => 404 and return unless (contact_list)

    contact = contact_list.contacts.build()

    contact.user_id = params[:user_id]

    if contact.save
      render :json => contact.to_json, :status => 201
    else
      head :status => 500 and return
    end
  end
end
