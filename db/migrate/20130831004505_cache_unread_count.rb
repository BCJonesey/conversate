class CacheUnreadCount < ActiveRecord::Migration
  def change
    add_column :reading_logs, :unread_count, :integer, :default => 0
  end
end
