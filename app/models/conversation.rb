class Conversation < ActiveRecord::Base
  include ConversationsHelper
  has_many :reading_logs
  has_many :users, :through => :reading_logs
  has_many :actions, :inverse_of => :conversation
  has_and_belongs_to_many :folders
  default_scope { includes(:folders, :users)}

  attr_accessible :title, :users, :most_recent_event

  after_initialize do |convo|
    convo.title = convo.default_conversation_title if (convo.title.nil? || convo.title.empty?)
  end

  def email_address
    # On kuhltank, set EMAIL_SUBDOMAIN=kuhltank
    subdomain = ENV['EMAIL_SUBDOMAIN']
    unless subdomain.nil?
      subdomain += '.'
    end
    "cnv-#{self.id}@#{subdomain}watercooler.io"
  end

  def set_title(title, user)
    if title
      self.title = title
      self.actions.new(type: 'retitle',
                       data: {title: title}.to_json,
                       user_id: user.id)
    end
  end

  def mark_all_unread_for(participants)
    participants.each do |participant|
      reading_log = ReadingLog.get(participant.id, self.id)
      unless reading_log.nil?
        reading_log.unread_count = self.actions.where(type: 'message').count
        reading_log.save
      end
    end
  end

  def add_participants(participants, user, create_action=true)
    if participants
      folder_set = Set.new(self.folders)
      participants.each do |p|
        user_id = p[:id] || p['id']
        u = User.find(user_id)
        self.users << u

        if folder_set.intersection(Set.new(u.folders)).length == 0
          u_default = Folder.find(u.default_folder_id)
          self.folders << u_default
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
    if participants
      participants.each do |p|
        user_id = p[:id] || p['id']
        u = User.find(user_id)
        self.users.delete u
      end

      # If everyone in a folder's been removed, those users probably shouldn't
      # be seeing it either.
      participant_set = self.users.to_set
      self.folders.each do |f|
        if participant_set.intersection(f.users.to_set).empty?
          self.folders.delete f
        end
      end

      if create_action
        self.actions.new(type: 'update_users',
                         data: {removed: participants}.to_json,
                         user_id: user.id)
      end

      self.save
    end
  end

  def add_folders(folders, user, create_action=true)
    if folders
      folders.each do |f|
        folder_id = f[:id] || f['id']
        folder = Folder.find(folder_id)
        self.folders << folder
      end

      if create_action
        self.actions.new(type: 'update_folders',
                         data: {added: folders}.to_json,
                         user_id: user.id)
      end

      self.save
    end
  end

  def remove_folders(folders, user, create_action=true)
    if folders
      folders.each do |f|
        folder_id = f[:id] || f['id']
        folder = Folder.find(folder_id)
        self.folders.delete folder
      end

      # Orphaning users by taking a conversation out of the only folder they
      # can see it in is bad.
      before = self.folders.clone
      self.users.each {|u| u.ensure_cnv_in_at_least_one_folder self }
      added = self.folders - before

      if create_action
        self.actions.new(type: 'update_folders',
                         data: {removed: folders, added: added}.to_json,
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
        action.save
        self.handle(action)
      end
    end
  end

  def participants
    self.users
  end

  def viewers
    (set_of_viewers() - self.participants).to_a
  end

  def viewers_and_participants
    (set_of_viewers() + self.participants).to_a
  end

  def can_user_update?(user)
    self.participants.include?(user) || self.viewers.include?(user)
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
  # TODO: This is used in one place, but not really. Remove it/do something with it.
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

  # TODO: Make one call. This is janky, but needed for folders right now.
  def unread_count_for_user(user)
    if (!participants.include?(user))
      return 0
    end
    reading_log = user.reading_logs.where(:conversation_id => self.id).first
    return unread_count(reading_log)
  end

  def as_json(options)
    json = super(options)

    # WARNING: Expensive call.
    user = User.includes(:folders).find_by_id(options[:user].id)
    reading_log = user.reading_logs.where(:conversation_id => self.id).first
    most_recent_viewed = most_recent_viewed_for_reading_log(reading_log)

    json[:participants] = participants;

    # A user might only be a shared conversation user, in which case they should have zero
    # unread messages.
    if (participants.include?(user))
      json[:unread_count] = unread_count(reading_log)
    else
      json[:unread_count] = 0
    end


    json[:most_recent_event] = most_recent_event ? most_recent_event.msec : nil

    # If the user has no most recent viewed, they are shared and we shouldn't care. Not returning
    # nil basically will make the client calculate 0 unread count too.
    json[:most_recent_viewed] = most_recent_viewed ? most_recent_viewed.msec : DateTime.now

    # TODO: Appears to be the slowest call here.
    json[:folder_ids] = []
    user.folders.each do |folder|
      if (folders.include?(folder))
        json[:folder_ids] << folder.id
      end
    end

    json[:archived] = reading_log ? reading_log.archived : false
    json[:pinned] = reading_log ? reading_log.pinned : false

    return json
  end

  def send_email_for(message)
    self.users.where(email_setting: always).each do |user|
      unless user == message.user
        EmailQueue.push(message, user)
      end
    end
  end

  def increment_unread_counts_for(message)
    self.users.each do |participant|
      unless participant == message.user
        reading_log = ReadingLog.get(participant.id, self.id)
        reading_log.unread_count += 1
        reading_log.save
      end
    end
  end

  def unarchive_for(message)
    self.users.each do |participant|
      reading_log = ReadingLog.get(participant.id, self.id)
      reading_log.archived = false
      reading_log.save
    end
  end

  def handle_message_actions(action)
    self.send_email_for action
    self.increment_unread_counts_for action
    self.unarchive_for action
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
      when 'update_folders'
        if action.added
          self.add_folders(action.added, action.user, false)
        end
        if action.removed
          self.remove_folders(action.removed, action.user, false)
        end
      when 'message'
        handle_message_actions action
      when 'email_message'
        handle_message_actions action
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

  private

  def set_of_viewers
    viewers_set = Set.new([])
    self.folders.each do |folder|
      viewers_set += folder.users.to_set
    end
    return viewers_set
  end
end
