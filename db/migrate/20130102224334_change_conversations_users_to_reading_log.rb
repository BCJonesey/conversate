class ChangeConversationsUsersToReadingLog < ActiveRecord::Migration
  def up
    rename_table "conversations_users", "reading_logs"

    change_table :reading_logs do |t|
      t.integer :last_read_event
    end
  end

  def down
    change_table :reading_logs do |t|
      t.remove :last_read_event
    end

    rename_table "reading_logs", "conversations_users"
  end
end
