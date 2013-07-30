class TopicsController < ApplicationController
  before_filter :require_login

  def show
    topic = Topic.find(params[:id])
    @topics = current_user.topics
    @conversations = Conversation.joins(:users, :topics)
                                 .where(users: {id: current_user.id},
                                        topics: {id: topic.id})
                                 .order('most_recent_event DESC')
    @conversation = @conversations.first
    @actions = @conversation ? @conversation.actions : nil
    @participants = @conversation ? @conversation.participants : nil

    render 'structural/show'
  end
end
