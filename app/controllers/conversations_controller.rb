class ConversationsController < ApplicationController
  before_filter :require_login
  before_filter :require_participation

  def show
    @topics = current_user.topics
    @conversation = Conversation.find(params[:id])
    @conversations = @conversation.topic.conversations
    @actions = @conversation.actions
    @participants = @conversation.participants

    render 'structural/show'
  end

  private

  # Internal: Verifies that the current user is a participant to the given
  # conversation.
  def require_participation
    unless current_user.in? Conversation.find(params[:id]).users
      render :not_participating
    end
  end

end
