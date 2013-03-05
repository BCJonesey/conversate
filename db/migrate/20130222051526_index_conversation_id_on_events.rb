class IndexConversationIdOnEvents < ActiveRecord::Migration
  def change
    add_index :events, :conversation_id
  end
end
