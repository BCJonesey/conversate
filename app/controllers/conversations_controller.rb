class ConversationsController < ApplicationController
  before_filter :require_login
  before_filter :require_participation

  def show
    @topics = Topic.all
    @conversation = Conversation.find(params[:id])
    topic = @conversation.topic
    @conversations = current_user.conversations.where(:topic_id => topic.id)
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
