class Conversation < ActiveRecord::Base
  include ConversationsHelper
  has_many :reading_logs
  has_many :users, :through => :reading_logs
  has_many :actions, :inverse_of => :conversation
  has_and_belongs_to_many :topics

  attr_accessible :title, :users, :most_recent_event

  after_initialize do |convo|
    convo.title = convo.default_conversation_title if (convo.title.nil? || convo.title.empty?)
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

  def unread_count(user)
    most_recent_viewed = most_recent_viewed_for_user(user)
    # Fudge the timestamp here because actions sometimes have timestamps in the middle
    # of seconds.
    # TODO: Figure out this Ruby timestamp bullshit.  We shouldn't have to fudge
    # this much.
    self.actions.where('created_at > ?', most_recent_viewed.in(2)).length
  end

  def as_json(options)
    json = super(options)
    # TODO: DRY.
    most_recent_viewed = most_recent_viewed_for_user(options[:user])
    json[:participants] = participants;

    json[:unread_count] = unread_count(options[:user]);
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
