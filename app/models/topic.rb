class Topic < ActiveRecord::Base
  has_and_belongs_to_many :conversations
  has_and_belongs_to_many :users

  attr_accessible :name

  validates_presence_of :name

  def as_json(options)
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
    unread_conversations = []
    conversations.each do |conversation|
      if conversation.unread_count_for_user(user) > 0
        unread_conversations.push(conversation.id)
      end
    end
    return unread_conversations
  end

  def debug_s
    "Topic:#{self.id}:#{self.name}"
  end
end
