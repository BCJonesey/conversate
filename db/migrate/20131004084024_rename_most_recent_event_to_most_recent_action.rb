class RenameMostRecentEventToMostRecentAction < ActiveRecord::Migration
  def change
    rename_column :conversations, :most_recent_event, :most_recent_action
  end
end
