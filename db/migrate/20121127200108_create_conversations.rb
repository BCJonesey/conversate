class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :subject, :default => nil

      t.timestamps
    end
  end
end
