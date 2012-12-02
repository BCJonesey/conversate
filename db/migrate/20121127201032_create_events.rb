class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :conversation_id
      t.integer :user_id
      t.string :type
      t.text :data # stored as json - for type-dependent information

      t.timestamps
    end
  end
end
