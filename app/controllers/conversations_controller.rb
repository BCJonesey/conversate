class ConversationsController < ApplicationController
  before_filter :require_login
  before_filter :require_participation

  def show
    # Due to some slightly unresolved technical/semantic debt, the UI query
    # string says "message" while the code here is all about actions.  This
    # should be the only line in the server code that talks about messages.
    params[:action_id] = params[:message]

    @folders = current_user.folders
    @conversation = Conversation.find(params[:id])
    folder = @conversation.folders.keep_if {|t| current_user.folders.include? t }.first
    @conversations = folder.conversations
    @actions = @conversation.actions
    @participants = @conversation.participants
    @folder = folder

    render 'structural/show'
  end

  private

  # Internal: Verifies that the current user is a participant to the given
  # conversation.
  def require_participation
    conversation = Conversation.find(params[:id])
    return if current_user.in? conversation.users

    conversation.folders.each do |t|
      return if t.in? current_user.folders
    end

    render :not_participating
  end

end
