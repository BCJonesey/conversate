class ConversationPiece
  attr_accessor :type, :user, :timestamp, :count

  def self.message(id, user, timestamp, message_id, text)
    Message.new id, user, timestamp, message_id, text
  end

  def self.set_title(id, user, timestamp, title)
    Retitle.new id, user, timestamp, title
  end

  def self.update_users(id, user, timestamp, added, removed)
    UpdateUsers.new id, user, timestamp, added, removed
  end

  def as_json(options={})
    json = super(options)
    # Javascript wants the timestamp to be in milliseconds.
    json[:timestamp] = timestamp.to_i * 1000
    json
  end

  private

  def initialize(type, user, timestamp, count)
    self.type = type
    self.user = user
    self.timestamp = timestamp
    self.count = count
  end

  class Message < ConversationPiece
    attr_accessor :id, :message_id, :text

    def initialize(id, user, timestamp, message_id, text)
      super :message, user, timestamp, 1
      self.id = id
      self.message_id = message_id
      self.text = text
    end

    def delete(id, user, timestamp)
      Deletion.new id, user, timestamp, self
    end
  end

  class Deletion < ConversationPiece
    attr_accessor :id, :original_message, :deletion_timestamp

    def initialize(id, user, timestamp, message)
      super :deletion, user, message.timestamp, 1
      self.id = id
      self.original_message = message
      self.deletion_timestamp = timestamp
    end
  end

  class Retitle < ConversationPiece
    attr_accessor :id, :title

    def initialize(id, user, timestamp, title)
      super :retitle, user, timestamp, 1
      self.id = id
      self.title = title
    end
  end

  class UpdateUsers < ConversationPiece
    attr_accessor :id, :added, :removed

    def initialize(id, user, timestamp, added, removed)
      super :update_users, user, timestamp, 1
      self.id = id
      self.added = added
      self.removed = removed
    end
  end
end
