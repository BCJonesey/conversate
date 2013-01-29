class Conversation < ActiveRecord::Base
  include ConversationsHelper
  has_many :reading_logs
  has_many :users, :through => :reading_logs
  has_many :events, :inverse_of => :conversation

  attr_accessible :title, :users

  after_initialize do |convo|
    convo.title = convo.default_conversation_title if (convo.title.nil? || convo.title.empty?)
  end

  # Public: Stitch together the events on a conversation into "conversation
  # pieces" that represent the current state of the conversation.  The current
  # state of a conversation consists of the latest version of the text of any
  # "wrote" events that haven't been deleted or moved into a different
  # conversation or sidebar, plus notices of any non-text events, such as
  # retitling the conversation or changing who has access to the conversation.
  #
  # In the future, consecutive conversation pieces that represent the same type of event -
  # deleting, sidebaring, etc (with the exception of "wrote" events) will be
  # collapsed into a single conversation piece.
  #
  # Returns an array of conversation pieces, in chronological order.
  def pieces
    # This will get slow on long conversations, but it's good enough for now
    conversation_pieces = []
    self.events.order('created_at ASC').each do |event|
      begin
        if event.event_type == 'message'
          conversation_pieces.append ConversationPiece.message(event.user, event.created_at, event.message_id, event.text)
        elsif event.event_type == 'retitle'
          conversation_pieces.append ConversationPiece.set_title(event.user, event.created_at, event.title)
        elsif event.event_type == 'deletion'
          index = conversation_pieces.index { |cp| cp.type == :message && cp.message_id == event.message_id }
          conversation_pieces[index] = conversation_pieces[index].delete(event.user, event.created_at)
        elsif event.event_type == 'user_update'
          conversation_pieces.append ConversationPiece.update_users(event.user, event.created_at, User.find(event.added), User.find(event.removed))
        end
      rescue
        raise "Error with #{event.data}: #{$!} (id: #{event.id})"
      end
    end
    conversation_pieces
  end

  def participants(current_user)
    active = self.events.order('created_at DESC').collect {|e| e.user}.uniq
    (active + (self.users - active) - [current_user]) - (active - self.users)
  end

  # Public: Gets the next id for a message in this conversation.
  #
  # Note - at the moment this just generates a random number and we're ignoring
  # the possibility of collisions. Fix this.
  def next_message_id
    (Random::rand * 10000).to_i
  end

  # Public: Determines if this conversation is unread for the given user.
  # A conversation is unread if (and only if) it contains a message event more
  # recent than the last event a user has seen.
  def unread_for?(user)
    messages = self.events.where(:event_type => 'message')
    return false if messages.length == 0

    last_read_event_id = self.reading_logs.where({:user_id => user.id}).first.last_read_event
    return true if last_read_event_id == nil

    messages.order('created_at DESC').first.created_at > Event.find(last_read_event_id).created_at
  end

  def as_json(options)
    json = super(options)
    json[:participants] = (users.length > 1) ?
      participants(options[:user]).map {|u| u.name}.join(', ') : " ";
    json[:class] = list_item_classes(self, options[:opened_conversation],
                                      options[:user])
    return json
  end

  protected
  # Internal: Creates a default conversation title based on who the participants
  # are.
  #
  # Returns "New Conversation" when there's only one user, or "A conversation
  # with <name>, <name>" for each user.
  def default_conversation_title()
    return 'New Conversation' if self.users.length <= 1
    "A conversation with #{self.users.map {|u| u.name}.join(', ')}"
  end
end
