class RenameTopicToFolder < ActiveRecord::Migration
  def change
    rename_table :topics, :folders
    rename_table :topics_users, :folders_users
    rename_column :folders_users, :topic_id, :folder_id
    rename_table :conversations_topics, :conversations_folders
    rename_column :conversations_folders, :topic_id, :folder_id
    rename_column :users, :default_topic_id, :default_folder_id
  end
end
