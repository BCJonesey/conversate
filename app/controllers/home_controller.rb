class HomeController < ApplicationController
  def index
    if logged_in?
      topic = current_user.topics.first
      if topic
        redirect_to topic_path(topic.slug, topic.id) and return
      else
        @topics = Topic.all
        @conversation = nil
        @conversations = []
        @actions = nil
        @participants = nil

        render 'structural/show' and return
      end
    end
  end

  def speakeasy
    session[:code_word] = params[:code_word]
    redirect_to marketing_url and return if params[:code_word] == SpeakeasyCode

    render :index
  end
end
