class Topic < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :conversations

  attr_accessible :name

  validates_presence_of :name

  def as_json(options)
    json = super(options)
    json['unread_conversations'] = unread_conversations(options[:user])
    return json
  end

  private

  def unread_conversations(user)
    unread_conversation_count = 0
    conversations.each do |conversation|
      if user.conversations.include?(conversation) && conversation.unread_for?(user)
        unread_conversation_count += 1
      end
    end
    return unread_conversation_count
  end

end
