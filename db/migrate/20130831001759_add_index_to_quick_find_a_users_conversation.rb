class AddIndexToQuickFindAUsersConversation < ActiveRecord::Migration
  def change
    add_index :reading_logs, [:user_id, :conversation_id, :most_recent_viewed],
      {name: "quick_find_most_reent_viewed"}
  end
end
