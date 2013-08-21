class ReadingLog < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  attr_accessible :conversation_id, :user_id, :last_read_event
end
