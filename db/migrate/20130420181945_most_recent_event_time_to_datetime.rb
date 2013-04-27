class MostRecentEventTimeToDatetime < ActiveRecord::Migration
  def up
    change_column :conversations, "most_recent_event", :datetime
  end

  def down
    change_column :conversations, "most_recent_event", :time
  end
end
