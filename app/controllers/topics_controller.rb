class TopicsController < ApplicationController
  before_filter :require_login

  def show
    conversation = Topic.find(params[:id]).conversations.order('updated_at DESC').first
    redirect_to conversation_path(conversation.id);
  end
end
