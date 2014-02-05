class Folder < ActiveRecord::Base
  has_and_belongs_to_many :conversations
  has_and_belongs_to_many :users

  attr_accessible :name, :email

  validates_presence_of :name

  default_scope { includes(:users) }

  def as_json(options)
    json = super(options)
    json['unread_conversations'] = unread_conversations(options[:user])
    json[:users] = users
    return json
  end

  def slug
    name.downcase
        .gsub(/[ _]/, '-')
        .gsub(/[^a-zA-Z0-9-]/, '')
  end

  def unread_conversations(user)
    unread_conversations = []
    conversations.each do |conversation|
      if conversation.unread_count_for_user(user) > 0
        unread_conversations.push(conversation.id)
      end
    end
    return unread_conversations
  end

  def self.find_by_email_insensitive(email)
    Folder.where('lower(email) = ?', email.downcase).first
  end

  def add_users(users_array, user)
    users_set = users_array.to_set - self.users.to_set

    if users_set.size > 0
      self.conversations.each do |c|
        conversation_users_set = users_set - c.participants.to_set - c.viewers.to_set

        if conversation_users_set.size > 0
          c.actions.build({
            user_id: user.id,
            data: { removed: [],
                    added:conversation_users_set}.to_json,
            type: "update_viewers"
          }).save
        end
      end

      self.users << users_set.to_a
      self.save
    end
  end

  def remove_users(users_array,user)
    users_set = users_array.to_set & self.users.to_set

    if users_set.size > 0
      self.users.delete(users_set.to_a)
      self.save

      self.conversations.each do |c|
	      c.participants.each{|u| u.ensure_cnv_in_at_least_one_folder c }
        conversation_users_set = users_set - c.participants.to_set - c.viewers.to_set

        if conversation_users_set.size > 0
          c.actions.build({
            user_id: user.id,
            data: { added: [],
                    removed:conversation_users_set}.to_json,
            type: "update_viewers"
          }).save
        end
      end
    end
  end

  def debug_s
    "Folder:#{self.id}:#{self.name}"
  end
end
