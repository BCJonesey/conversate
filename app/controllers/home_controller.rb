class HomeController < ApplicationController
  def index
    if logged_in?
      topic = Topic.first
      if topic
        redirect_to topic_path(topic.slug, topic.id);
      else
        @topics = Topic.all
        @conversation = nil
        @conversations = []
        @actions = nil
        @participants = nil

        render 'structural/show'
      end
    else
      render 'sessions/new'
    end
  end
end
