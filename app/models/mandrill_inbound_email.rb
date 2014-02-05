class MandrillInboundEmail
  CNV_REGEX = /(.*)@([^.]*)\.?watercoole?r\.io/

  attr_reader :sender, :action, :conversation, :subdomain, :recipient, :folder

  def initialize(data)
    @data = data
    @sender = User.find_by_email_insensitive(@data['from_email'])
    initialize_new_user if @sender.nil?
    reply_text = EmailReplyParser.parse_reply(@data['text'])
    @action = Action.new(
      type: 'email_message',
      data: { text: reply_text,
              full_text: @data['text'] }.to_json,
      user_id: @sender.id
    )
    CNV_REGEX =~ @data['email']
    @recipient = $1
    @subdomain = $2

    case @recipient
      when /cnv-(\d+)/
        @conversation = Conversation.find($1)
      when /(.*)/
        @folder = Folder.find_by_email_insensitive($1)
        @subject = @data['subject']
      else
        Rails.logger.warn "Inbound mail can't match any address pattern."
    end
  end

  def to_conversation?
    !@conversation.nil?
  end

  def to_folder?
    !@folder.nil?
  end

  def dispatch
    if self.to_conversation?
      self.dispatch_to_conversation
    elsif self.to_folder?
      self.dispatch_to_folder
    else
      Rails.logger.warn "Inbound email sent to unknown address: #{@data['email']}"
    end
  end
  def dispatch_to_conversation
    self.action.save
    self.conversation.actions << self.action
    conversation.update_most_recent_event
    @sender.update_most_recent_viewed conversation
    self.conversation.handle action
  end

  def dispatch_to_folder
    @conversation =  @folder.conversations.create()
    conversation.set_title @subject, @sender
    conversation.add_participants [@sender], @sender
    conversation.reload
    self.dispatch_to_conversation
  end

  def initialize_new_user
    @sender = User.build({email:  @data['from_email'], full_name: @data['from_name'] || "", external: true})
    raise "Could not create external user" if @sender.nil?
  end
end
