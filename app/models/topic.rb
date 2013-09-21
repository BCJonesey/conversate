class Topic < ActiveRecord::Base
  has_and_belongs_to_many :conversations
  has_and_belongs_to_many :users

  attr_accessible :name

  validates_presence_of :name

  default_scope includes(:users)

  def as_json(options)
    options.merge!({:include=>[:users]}) unless options.include?(:include)
    options[:include] = ([options[:include]]) unless options[:include].is_a?(Array)
    options[:include] << :users unless options[:include].include?(:users)
    json = super(options)
    json['unread_conversations'] = unread_conversations(options[:user])
    return json
  end

  def slug
    name.downcase
        .gsub(/[ _]/, '-')
        .gsub(/[^a-zA-Z0-9-]/, '')
  end

  def unread_conversations(user)
    unread_conversation_count = 0
    # conversations.each do |conversation|
    #   if user.conversations.include?(conversation) && conversation.unread_count(user) > 0
    #     unread_conversation_count += 1
    #   end
    # end
    return unread_conversation_count
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
	      c.participants.each{|u| c.ensure_user_has_in_topic(u)}
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
    "Topic:#{self.id}:#{self.name}"
  end
end
