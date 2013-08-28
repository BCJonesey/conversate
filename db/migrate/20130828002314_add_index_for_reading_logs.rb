class AddIndexForReadingLogs < ActiveRecord::Migration
  def change
    add_index :reading_logs, :conversation_id
    add_index :reading_logs, :user_id
  end
end
