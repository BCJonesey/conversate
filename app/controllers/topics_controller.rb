class TopicsController < ApplicationController
  before_filter :require_login

  def show
    topic = Topic.find(params[:id])
    respond_to do |format|
      format.html {
        conversation = topic.conversations.order('updated_at DESC').first
        if conversation
          redirect_to conversation_path(conversation.id)
        else
          @conversations = []
          @opened_conversation = nil
          @opened_topic = topic
          @new_conversation = false
          render 'conversations/index'
        end
      }
      format.json {
        if (params[:conversation])
          opened_conversation = Conversation.find(params[:conversation])
        end

        render :json => topic.conversations.to_json(:user => current_user, :opened_conversation => opened_conversation)
      }
    end
  end

  def create
    topic = Topic.new(:name => params[:name])
    topic.save
    current_user.topics << topic
    redirect_to :back
  end
end
