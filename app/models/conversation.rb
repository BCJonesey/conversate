class Conversation < ActiveRecord::Base
  include ConversationsHelper
  has_many :reading_logs
  has_many :users, :through => :reading_logs
  has_many :actions, :inverse_of => :conversation
  has_and_belongs_to_many :topics

  attr_accessible :title, :users, :most_recent_event

  after_initialize do |convo|
    convo.title = convo.default_conversation_title if (convo.title.nil? || convo.title.empty?)
    convo.most_recent_event = Time.now
  end

  # Public: Stitch together the actions on a conversation into "conversation
  # pieces" that represent the current state of the conversation.  The current
  # state of a conversation consists of the latest version of the text of any
  # "wrote" actions that haven't been deleted or moved into a different
  # conversation or sidebar, plus notices of any non-text actions, such as
  # retitling the conversation or changing who has access to the conversation.
  #
  # In the future, consecutive conversation pieces that represent the same type of action -
  # deleting, sidebaring, etc (with the exception of "wrote" actions) will be
  # collapsed into a single conversation piece.
  #
  # Returns an array of conversation pieces, in chronological order.
  def pieces
    # This will get slow on long conversations, but it's good enough for now
    conversation_pieces = []
    self.actions.order('created_at ASC').each do |action|
      begin
        if action.event_type == 'message'
          conversation_pieces.append ConversationPiece.message(action.id, action.user, action.created_at, action.message_id, action.text)
        elsif action.event_type == 'retitle'
          conversation_pieces.append ConversationPiece.set_title(action.id, action.user, action.created_at, action.title)
        elsif action.event_type == 'deletion'
          index = conversation_pieces.index { |cp| cp.type == :message && cp.message_id == action.message_id }
          # We should track down how this might be nil.
          unless index.nil?
            conversation_pieces[index] = conversation_pieces[index].delete(action.id, action.user, action.created_at)
          end
        elsif action.event_type == 'user_update'
          conversation_pieces.append ConversationPiece.update_users(action.id, action.user, action.created_at, User.find(action.added), User.find(action.removed))
        end
      rescue
        raise "Error with #{action.data}: #{$!} (id: #{action.id})"\
      end
    end
    conversation_pieces
  end

  def participants(current_user)
    # active = self.actions.order('created_at DESC').collect {|e| e.user}.uniq
    # (active + (self.users - active) - [current_user]) - (active - self.users)
    # The above call is very expensive.
    self.users - [current_user]
  end

  # Public: Gets the next id for a message in this conversation.
  #
  # Note - at the moment this just generates a random number and we're ignoring
  # the possibility of collisions. Fix this.
  def next_message_id
    (Random::rand * 10000).to_i
  end

  # Public: Determines if this conversation is unread for the given user.
  # A conversation is unread if (and only if) it contains a message action more
  # recent than the last action a user has seen.
  def unread_for?(user)
    messages = self.actions.where(:event_type => 'message')
    return false if messages.length == 0

    last_read_action_id = self.reading_logs.where({:user_id => user.id}).first.last_read_event
    return true if last_read_action_id == nil

    messages.order('created_at DESC').first.created_at > Action.find(last_read_action_id).created_at
  end

  def update_most_recent_action
    most_recent_action = Time.now
    save
  end

  def as_json(options)
    json = super(options)
    # TODO: DRY.
    participants = participants(options[:user])
    json[:participants] = (users.length > 1) ?
    participants.map {|u| u.name}.join(', ') : " ";
    json[:class] = list_item_classes(self, options[:opened_conversation],
                                     options[:user])
    json[:participant_tokens] = participants
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
