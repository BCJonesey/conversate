class ConvertLastReadEventToTimestamp < ActiveRecord::Migration
  class ReadingLog < ActiveRecord::Base
  end
  class Action < ActiveRecord::Base
  end

  def up
    add_column :reading_logs, :most_recent_viewed, :datetime

    ReadingLog.all.each do |log|
      if (log.last_read_event)
        action = Action.find(log.last_read_event)
        log.most_recent_viewed = action.timestamp
      else
        log.most_recent_viewed = nil
      end
    end

    remove_column :reading_logs, :last_read_event
  end

  def down
  end
end
