class CreateConversationUserJoinTable < ActiveRecord::Migration
  def change
    create_table :conversations_users, :id => false do |t|
      t.integer :conversation_id
      t.integer :user_id
    end
  end
end
