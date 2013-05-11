class AddMostRecentEventToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :most_recent_event, :time, :default => '2000-01-01 01:07:19'
  end
end
