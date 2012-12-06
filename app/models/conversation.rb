class Conversation < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :events, :inverse_of => :conversation

  attr_accessible :subject, :users

  def initialize(params={})
    super params
    self.subject = default_conversation_title(self.users) unless self.subject
  end

  # Public: Stitch together the events on a conversation into "conversation
  # pieces" that represent the current state of the conversation.  The current
  # state of a conversation consists of the latest version of the text of any
  # "wrote" events that haven't been deleted or moved into a different
  # conversation or sidebar, plus notices of any non-text events, such as
  # retitling the conversation or changing who has access to the conversation.
  #
  # Consecutive conversation pieces that represent the same type of event -
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
          conversation_pieces.select {|cp| cp.type == :message && cp.message_id == event.message_id }.first.delete(event.user, event.created_at)
        end
      rescue
        raise "Error with #{event.data}: #{$!} (id: #{event.id})"
      end
    end
    conversation_pieces
  end

  # Public: Gets the next id for a message in this conversation.
  #
  # Note - at the moment this just generates a random number and we're ignoring
  # the possibility of collisions. Fix this.
  def next_message_id
    (Random::rand * 10000).to_i
  end

  private
  # Internal: Creates a default conversation title based on who the participants
  # are.
  #
  # Returns "Conversation with <name>, <name>" for each user.
  def default_conversation_title(users)
    "Conversation with #{users.map {|u| u.name}.join(', ')}"
  end
end
