class MostRecentEventTimeToDatetime < ActiveRecord::Migration
  class Conversation < ActiveRecord::Base
    has_many :actions, :inverse_of => :conversation
  end
  class Action < ActiveRecord::Base
    belongs_to :conversation, :inverse_of => :actions
  end

  def up
    remove_column :conversations, 'most_recent_event'
    add_column :conversations, 'most_recent_event', :datetime, :default => '2000-01-01 01:07:19'

    Conversation.all.each do |conversation|
      most_recent = conversation.actions.order('created_at DESC').first
      if (most_recent)
        conversation.most_recent_event = most_recent.created_at
        conversation.save
      end
    end
  end

  def down
    change_column :conversations, "most_recent_event", :time
  end
end
