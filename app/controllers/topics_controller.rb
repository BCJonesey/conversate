class TopicsController < ApplicationController
  before_filter :require_login

  def show
    topic = Topic.find(params[:id])
    @topics = Topic.all
    @conversations = current_user.conversations.where(:topic_id => topic.id)
                                               .order('most_recent_event DESC')
    @conversation = @conversations.first
    @actions = @conversation ? @conversation.actions : nil
    @participants = @conversation ? @conversation.participants : nil

    render 'structural/show'
  end
end
