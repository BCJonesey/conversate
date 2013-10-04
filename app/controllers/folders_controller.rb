class FoldersController < ApplicationController
  before_filter :require_login

  def show
    folder = Folder.find(params[:id])

    @folder = folder
    @folders = current_user.folders
    @conversations = folder.conversations.order('most_recent_action DESC')
    @conversation = @conversations.first
    @actions = @conversation ? @conversation.actions : nil
    @participants = @conversation ? @conversation.participants : nil

    render 'structural/show'
  end
end
