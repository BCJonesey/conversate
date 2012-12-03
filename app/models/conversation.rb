class Conversation < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :events, :inverse_of => :conversation

  # Public: Stitch together the events on a conversation into "conversation
  # pieces" that represent the current state of the conversation.  The current
  # state of a conversation consists of the latest version of the text of any
  # "wrote" events that haven't been deleted or moved into a different
  # conversation or sidebar, plus notices of any non-text events, such as
  # retitling the conversation or changing who has access to the conversation.
  #
  # Consecutive conversation pieces that represent the same type of event -
  # deleting, sidebaring, etc (with the exception of "wrote" events) will be
  # collapsed into a single conversation piece.
  #
  # Returns an array of conversation pieces, in chronological order.
  def pieces
  end
end
