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

  def set_title(title, user)
    if title
      self.title = title
      self.actions.new(type: 'retitle',
                       data: {title: title}.to_json,
                       user_id: user.id)
    end
  end

  def add_participants(participants, user, create_action=true)
    if participants
      topic_set = Set.new(self.topics)
      participants.each do |p|
        user_id = p[:id] || p['id']
        u = User.find(user_id)
        self.users << u
        if topic_set.intersection(Set.new(u.topics)).length == 0
          u_default = Topic.find(u.default_topic_id)
          self.topics << u_default
        end
      end
      self.save

      if create_action
        self.actions.new(type: 'update_users',
                         data: {added: participants}.to_json,
                         user_id: user.id)
      end
    end
  end

  def remove_participants(participants, user, create_action=true)
    # TODO: Sometimes remove some topics - semantics TBD
    if participants
      participants.each do |p|
        user_id = p[:id] || p['id']
        u = User.find(user_id)
        self.users.delete u
      end

      if create_action
        self.actions.new(type: 'update_users',
                         data: {removed: participants}.to_json,
                         user_id: user.id)
      end

      self.save
    end
  end

  def add_topics(topics, user, create_action=true)
    if topics
      topics.each do |t|
        topic_id = t[:id] || t['id']
        topic = Topic.find(topic_id)
        self.topics << topic
      end

      if create_action
        self.actions.new(type: 'update_topics',
                         data: {added: topics}.to_json,
                         user_id: user.id)
      end

      self.save
    end
  end

  def remove_topics(topics, user, create_action=true)
    if topics
      topics.each do |t|
        topic_id = t[:id] || t['id']
        topic = Topic.find(topic_id)
        self.topics.delete topic
      end

      if create_action
        self.actions.new(type: 'update_topics',
                         data: {removed: topics}.to_json,
                         user_id: user.id)
      end

      self.save
    end
  end

  def add_actions(actions, user)
    if actions
      actions.each do |a|
        action = self.actions.new(type: a[:type],
                                  data: Action::data_for_params(a),
                                  user_id: user.id)
        self.handle(action)
        action.save
      end
    end
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
    return false
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
    reading_log = user.reading_logs.where(:conversation_id => self.id).first
    return nil unless reading_log
    most_recent_viewed = reading_log.most_recent_viewed
    return DateTime.parse('2000-01-01 01:07:19 UTC') unless most_recent_viewed
    return most_recent_viewed
  end

  def most_recent_viewed_for_reading_log(reading_log)
    return nil unless reading_log
    most_recent_viewed = reading_log.most_recent_viewed
    return DateTime.parse('2000-01-01 01:07:19 UTC') unless most_recent_viewed
    return most_recent_viewed
  end

  def unread_count(reading_log)
    return 0 unless reading_log
    return reading_log.unread_count
  end

  def as_json(options)
    json = super(options)

    # WARNING: Expensive call.
    user = options[:user]
    reading_log = user.reading_logs.where(:conversation_id => self.id).first
    most_recent_viewed = most_recent_viewed_for_reading_log(reading_log)

    json[:participants] = participants;
    json[:unread_count] = unread_count(reading_log)

    json[:most_recent_event] = most_recent_event ? most_recent_event.msec : nil
    json[:most_recent_viewed] = most_recent_viewed ? most_recent_viewed.msec : nil

    # TODO: Appears to be the slowest call here.
    json[:topic_ids] = []
    user.topics.each do |topic|
      if (topics.include?(topic))
        json[:topic_ids] << topic.id
      end
    end

    return json
  end

  def handle(action)
    case action.type
      when 'retitle'
        self.title = action.title
      when 'update_users'
        if action.added
          self.add_participants(action.added, action.user, false)
        end
        if action.removed
          self.remove_participants(action.removed, action.user, false)
        end
      when 'update_topics'
        if action.added
          self.add_topics(action.added, action.user, false)
        end
        if action.removed
          self.remove_topics(action.removed, action.user, false)
        end
    end
    save
  end

  def debug_s
    "Conversation:#{self.id}:#{self.title}"
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
