class MandrillInboundEmail
  CNV_REGEX = /cnv-(\d+)@(.*)\.watercoolr\.io/

  attr_reader :sender, :action, :conversation, :subdomain, :domain, :recipient, :folder

  def initialize(data)
    @data = data
    @sender = User.find_by_email(@data['from_email']) unless @user
    @action = Action.new(
      type: 'email_message',
      data: { text: @data['text'] }.to_json,
      user_id: self.sender_user.id
    )
    CNV_REGEX =~ @data['email']
    @recipient = $1
    @subdomain = $2

    case @recipient
      when /cnv-(\d+)/
        @conversation = Conversation.find($1)
      when /(\d+)/
        @folder = Folder.find($1)
    end
  end

  def to_conversation?
    !@conversation.nil?
  end

  def dispatch
    if !@conversation.nil?
      self.dispatch_to_conversation
    elsif !folder.nil?
      self.dispatch_to_folder
    end
  end
  def dispatch_to_conversation
    self.action.save
    self.conversation.actions << self.action
    # TODO: make handle deal with unread counts
    self.conversation.handle action
  end

  def dispatch_to_folder
    @conversation =  @folder.conversations.create()
    conversation.set_title params[:title]
    conversation.add_participants [@sender], @sender
    self.dispatch_to_conversation
  end
end
