class ConversationsController < ApplicationController
  before_filter :require_login
  before_filter :require_participation

  def show
    @topics = current_user.topics
    @conversation = Conversation.find(params[:id])
    topic = @conversation.topics.keep_if {|t| current_user.topics.include? t }.first
    @conversations = topic.conversations
    @actions = @conversation.actions
    @participants = @conversation.participants

    render 'structural/show'
  end

  private

  # Internal: Verifies that the current user is a participant to the given
  # conversation.
  def require_participation
    conversation = Conversation.find(params[:id])
    return if current_user.in? conversation.users

    conversation.topics.each do |t|
      return if t.in? current_user.topics
    end

    render :not_participating
  end

end
