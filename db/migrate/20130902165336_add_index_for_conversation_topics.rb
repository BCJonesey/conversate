class AddIndexForConversationTopics < ActiveRecord::Migration
  def change
    add_index :conversations_topics, [:conversation_id, :topic_id]
    add_index :conversations_topics, [:topic_id, :conversation_id]
  end
end
