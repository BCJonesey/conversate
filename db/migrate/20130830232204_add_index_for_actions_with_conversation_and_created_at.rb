class AddIndexForActionsWithConversationAndCreatedAt < ActiveRecord::Migration
  def change
    add_index :actions, [:conversation_id, :created_at]
  end
end
