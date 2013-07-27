class CreateTopicsUsersTable < ActiveRecord::Migration
  def up
    create_table :topics_users do |t|
      t.integer :conversation_id
      t.integer :user_id
    end
  end

  def down
    drop_table :topics_users
  end
end
