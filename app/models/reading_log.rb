class ReadingLog < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  validates :user_id, uniqueness: { scope: :conversation_id }
  attr_accessible :conversation_id, :user_id, :last_read_event

  # This is a pretty terrible name, but the whole point of this method is to
  # have a shorter name than the method it calls, and I don't have a better
  # name than this.
  def ReadingLog.get(user_id, conversation_id)
    ReadingLog.find_by_user_id_and_conversation_id user_id, conversation_id
  end
end
