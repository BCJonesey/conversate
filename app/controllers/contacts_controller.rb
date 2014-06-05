class ContactsController < ApplicationController
  before_filter :require_login

  def index
    @folder = current_user.folders.first
    @folders = current_user.folders
    @conversation = nil
    @conversations = []
    @actions = nil
    @participants = nil

    render 'structural/show' and return
  end
end
