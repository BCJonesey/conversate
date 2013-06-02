class TopicsController < ApplicationController
  before_filter :require_login

  def show
    topic = Topic.find(params[:id])
    @topics = current_user.topics
    @conversations = topic.conversations
    @conversation = topic.conversations.first
    @actions = @conversation ? @conversation.actions : nil
    @participants = @conversation ? @conversation.participants : nil

    render 'structural/show'
  end
end
