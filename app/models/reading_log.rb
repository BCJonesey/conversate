class ReadingLog < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  validates :user_id, uniqueness: { scope: :conversation_id }
  attr_accessible :conversation_id, :user_id, :last_read_event
end
