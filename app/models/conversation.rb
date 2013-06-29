class Conversation < ActiveRecord::Base
  include ConversationsHelper
  has_many :reading_logs
  has_many :users, :through => :reading_logs
  has_many :actions, :inverse_of => :conversation
  belongs_to :topic

  attr_accessible :title, :users, :most_recent_event

  after_initialize do |convo|
    convo.title = convo.default_conversation_title if (convo.title.nil? || convo.title.empty?)
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
        if action.type == 'message'
          conversation_pieces.append ConversationPiece.message(action.id, action.user, action.created_at, action.message_id, action.text)
        elsif action.type == 'retitle'
          conversation_pieces.append ConversationPiece.set_title(action.id, action.user, action.created_at, action.title)
        elsif action.type == 'deletion'
          index = conversation_pieces.index { |cp| cp.type == :message && cp.message_id == action.message_id }
          # We should track down how this might be nil.
          unless index.nil?
            conversation_pieces[index] = conversation_pieces[index].delete(action.id, action.user, action.created_at)
          end
        elsif action.type == 'update_users'
          conversation_pieces.append ConversationPiece.update_users(action.id, action.user, action.created_at, User.find(action.added), User.find(action.removed))
        end
      rescue
        raise "Error with #{action.data}: #{$!} (id: #{action.id})"\
      end
    end
    conversation_pieces
  end

  def participants
    self.users
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
    messages = self.actions.where(:type => 'message')
    return false if messages.length == 0

    most_recent_viewed = most_recent_viewed_for_user(user)
    # Fudge the timestamp here because actions sometimes have timestamps in the middle
    # of seconds.
    # TODO: Figure out this Ruby timestamp bullshit.  We shouldn't have to fudge
    # this much.
    return messages.order('created_at DESC').first.created_at > most_recent_viewed.in(2)
  end

  def update_most_recent_event
    self.most_recent_event = Time.now
    self.save
  end

  def most_recent_viewed_for_user(user)
    most_recent_viewed = user.reading_logs.where(:conversation_id => self.id).first.most_recent_viewed
    return DateTime.parse('2000-01-01 01:07:19 UTC') unless most_recent_viewed
    return most_recent_viewed
  end

  def as_json(options)
    json = super(options)
    # TODO: DRY.
    most_recent_viewed = most_recent_viewed_for_user(options[:user])
    json[:participants] = participants;
    # Fudge the timestamp here because actions sometimes have timestamps in the middle
    # of seconds.
    # TODO: Figure out this Ruby timestamp bullshit.  We shouldn't have to fudge
    # this much.
    json[:unread_count] = self.actions.where('created_at > ?', most_recent_viewed.in(2)).length
    json[:most_recent_event] = most_recent_event ? most_recent_event.msec : nil
    json[:most_recent_viewed] = most_recent_viewed ? most_recent_viewed.msec : nil
    return json
  end

  def handle(action)
    case action.type
    when 'retitle'
      self.title = action.title
    when 'update_users'
      if action.added
        action.added.map do |action_user|
          user = User.find_by_id(action_user['id'])
          self.users << user
        end
      end
      if action.removed
        action.removed.each do |action_user|
          user = User.find_by_id(action_user['id'])
          self.users.delete(user)
        end
      end
    end
    save
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
