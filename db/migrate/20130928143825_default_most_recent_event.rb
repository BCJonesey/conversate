class DefaultMostRecentEvent < ActiveRecord::Migration
  def change
    change_column_default :conversations, :most_recent_event, DateTime.new(2000, 1, 1, 1, 7, 19);
  end
end
