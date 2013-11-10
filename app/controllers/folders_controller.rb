class FoldersController < ApplicationController
  before_filter :require_login

  def show
    folder = Folder.find(params[:id])

    @folder = folder
    @folders = current_user.folders
    @conversations = folder.conversations.joins(:reading_logs).order('most_recent_event DESC')
    @conversation = @conversations.where('reading_logs.user_id' => current_user.id,
                                          'reading_logs.archived' => false)[0]
    @actions = @conversation ? @conversation.actions : nil
    @participants = @conversation ? @conversation.participants : nil

    render 'structural/show'
  end
end
