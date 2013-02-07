class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name, :null => false
      t.timestamps
    end

    create_table :conversations_topics do |t|
      t.integer :conversation_id
      t.integer :topic_id
    end

    create_table :topics_users do |t|
      t.integer :user_id
      t.integer :topic_id
    end
  end
end
