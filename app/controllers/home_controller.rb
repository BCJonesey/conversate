class HomeController < ApplicationController
  def index
    if logged_in?
      topic = Topic.first
      redirect_to(topic_path(topic.slug, topic.id));
    else
      render 'sessions/new'
    end
  end
end
