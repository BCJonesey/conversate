class AddMostRecentEventToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :most_recent_event, :time, :default => Time.now
  end
end
