class AddIndexForUsersTopics < ActiveRecord::Migration
  def change
    add_index :topics_users, [:user_id, :topic_id]
    add_index :topics_users, [:topic_id, :user_id]
  end
end
