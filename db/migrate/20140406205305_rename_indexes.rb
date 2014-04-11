class RenameIndexes < ActiveRecord::Migration
  def change
    rename_index :actions,
                 'index_events_on_conversation_id',
                 'index_actions_on_conversation_id'
    rename_index :conversations_folders,
                 'index_conversations_topics_on_conversation_id_and_topic_id',
                 'index_conversations_folders_on_conversation_id_and_folder_id'
    rename_index :conversations_folders,
                 'index_conversations_topics_on_topic_id_and_conversation_id',
                 'index_conversations_folders_on_folder_id_and_conversation_id'
    rename_index :folders_users,
                 'index_topics_users_on_topic_id_and_user_id',
                 'index_folders_users_on_folder_id_and_user_id'
    rename_index :folders_users,
                 'index_topics_users_on_user_id_and_topic_id',
                 'index_folders_users_on_user_id_and_folder_id'

  end
end
