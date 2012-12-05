class ConversationPiece
  attr_accessor :type, :user, :timestamp, :count

  def self.message(user, timestamp, message_id, text)
    Message.new user, timestamp, message_id, text
  end

  def self.set_title(user, timestamp, title)
    Retitle.new user, timestamp, title
  end

  private

  def initialize(type, user, timestamp, count)
    self.type = type
    self.user = user
    self.timestamp = timestamp
    self.count = count
  end

  class Message < ConversationPiece
    attr_accessor :message_id, :text

    def initialize(user, timestamp, message_id, text)
      super :message, user, timestamp, 1
      self.message_id = message_id
      self.text = text
    end

    def delete(user, timestamp)
    end
  end

  class Retitle < ConversationPiece
    attr_accessor :title

    def initialize(user, timestamp, title)
      super :retitle, user, timestamp, 1
      self.title = title
    end
  end
end
