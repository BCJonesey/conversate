class AddTopicIdToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :topic_id, :integer, :default => 1
  end
end
