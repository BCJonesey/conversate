class DropTopicUsersAndTopicConversationsTables < ActiveRecord::Migration
  def up
    drop_table :topics_users
    drop_table :conversations_topics
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
