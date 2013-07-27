class CreateConversationsTopicsTable < ActiveRecord::Migration
  def up
    create_table :conversations_topics do |t|
      t.integer :conversation_id
      t.integer :topic_id
    end

    remove_column :conversations, :topic_id
  end

  def down
    drop_table :conversations_topics

    change_table :conversations do |t|
      t.integer :topic_id
    end
  end
end
