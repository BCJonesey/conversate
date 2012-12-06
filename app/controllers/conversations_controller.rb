class ConversationsController < ApplicationController
  before_filter :require_login

  def index
    @conversations = current_user.conversations.order('updated_at DESC')
  end

  def new
    @conversation_errors = []
  end

  def create
    @conversation_errors = []
    if params[:users].length > 0
      users = User.find params[:users]
      conversation = Conversation.new({:users => (users << current_user).uniq,
                                       :subject => params[:subject]})
      @conversation_errors << 'Failed to save conversation' unless conversation.save

      if params[:subject]
        title_event = Event.new({:conversation_id => conversation.id,
                                 :user_id => current_user.id,
                                 :event_type => 'retitle',
                                 :data => {:title => conversation.subject}.to_json})
        @conversation_errors << 'Failed to save title event' unless title_event.save
      end

      if params[:first_message]
        message_event = Event.new({:conversation_id => conversation.id,
                                   :user_id => current_user.id,
                                   :event_type => 'message',
                                   :data => {:message_id => conversation.next_message_id,
                                             :text => params[:first_message]}.to_json})
        @conversation_errors << 'Failed to save message event' unless message_event.save
      end
    else
      @conversation_errors << 'No senders'
    end

    if @conversation_errors.length > 0
      render :new
    else
      @conversations = current_user.conversations.order('updated_at DESC')
      render :index
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def update
    raise "Not implemented"
  end
end
