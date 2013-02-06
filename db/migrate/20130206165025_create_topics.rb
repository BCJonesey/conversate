class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.timestamps
      t.string :name, :null => false
    end

    change_table :reading_logs do |t|
      t.integer :topic_id, :default => nil
    end
  end
end
