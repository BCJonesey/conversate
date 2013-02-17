class ConversationsController < ApplicationController
  before_filter :require_login
  before_filter :require_participation, :except => [:index, :new]

  def index
    respond_to do |format|
      format.html {
        conversations = user_conversations
        redirect_to conversation_path(conversations.first.id) and return unless conversations.length == 0
      }
      format.json {

        # This is for later list_item class determination.
        if (params[:id])
          opened_conversation = Conversation.find(params[:id])
        end

        render :json => user_conversations(opened_conversation).to_json(:user => current_user,
                                    :opened_conversation => opened_conversation)
      }
    end
  end

  def new
    conversation = Conversation.new
    conversation.users.push current_user
    conversation.save!

    session[:new_conversation] = true
    redirect_to conversation_path(conversation.id)
  end

  def show
    conversation = Conversation.find(params[:id])
    current_user.mark_as_read(conversation)

    respond_to do |format|
      format.html { render_conversation_view conversation }
      format.json { render :json => conversation.pieces.to_json }
    end
  end

  def retitle
    conversation = Conversation.find(params[:id])
    if params[:title].empty? || params[:title] == conversation.title
      render_conversation_view(conversation) and return
    end

    conversation.title = params[:title]
    title_event = Event.new({:conversation_id => conversation.id,
                             :user_id => current_user.id,
                             :event_type => 'retitle',
                             :data => {:title => params[:title]}.to_json})
    conversation.save
    title_event.save
    render_conversation_view conversation
  end

  def write
    respond_to do |format|
      format.html {
        conversation = Conversation.find(params[:id])
        render_conversation_view(conversation) and return if params[:text].empty?

        message_event = Event.new({:conversation_id => conversation.id,
                                   :user_id => current_user.id,
                                   :event_type => 'message',
                                   :data => {:message_id => conversation.next_message_id,
                                             :text => params[:text]}.to_json})
        message_event.save
        current_user.mark_as_read(conversation)
        render_conversation_view conversation
      }
      format.json {

      }
    end
  end

  def delete
    conversation = Conversation.find(params[:id])
    render_conversation_view(conversation) and return if params[:message].empty?

    delete_event = Event.new({:conversation_id => conversation.id,
                              :user_id => current_user.id,
                              :event_type => 'deletion',
                              :data => {:message_id => params[:message].to_i}.to_json})
    delete_event.save
    render_conversation_view conversation
  end

  def update_users
    conversation = Conversation.find(params[:id])
    updated_users = User.find(params[:users].split(',').collect {|u| u.to_i})
    removed_users = conversation.users - updated_users - [current_user]
    added_users = updated_users - conversation.users

    puts "original #{conversation.users.map{|u| u.name}.join(',')}"
    puts "update   #{updated_users.map{|u| u.name}.join(',')}"
    puts "remove   #{removed_users.map{|u| u.name}.join(',')}"
    puts "added    #{added_users.map{|u| u.name}.join(',')}"

    user_event = Event.new({:conversation_id => conversation.id,
                            :user_id => current_user.id,
                            :event_type => 'user_update',
                            :data => {:added => added_users.collect {|u| u.id },
                                      :removed => removed_users.collect {|u| u.id }}.to_json})
    conversation.reading_logs.where(:user_id => removed_users.collect {|u| u.id }).delete_all
    added_users.each do |u|
      rl = ReadingLog.new({:conversation_id => conversation.id,
                           :user_id => u.id})
      rl.save!
    end
    user_event.save!
    render_conversation_view conversation.reload
  end

  private
  def user_conversations(topic = nil)
    if topic
      topic.conversations.order('updated_at DESC')
    else
      current_user.conversations.order('updated_at DESC')
    end
  end

  def render_conversation_view(conversation=nil)
    topic = nil
    if conversation
      topic = Topic.find(conversation.reading_logs.where(:user_id => current_user.id).first.topic_id)
    end
    @conversations = user_conversations(topic)
    @opened_conversation = conversation
    @new_conversation = session[:new_conversation].nil? ? false : session[:new_conversation]
    session[:new_conversation] = false

    render :index
  end

  # Internal: Verifies that the current user is a participant to the given
  # conversation.
  def require_participation
    unless current_user.in? Conversation.find(params[:id]).users
      @conversations = current_user.conversations.order('updated_at DESC')
      render :not_participating
    end
  end
end
