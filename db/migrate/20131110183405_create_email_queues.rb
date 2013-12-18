class CreateEmailQueues < ActiveRecord::Migration
  def change
    create_table :email_queues do |t|
      t.integer :action_id
      t.integer :external_user_id

      t.timestamps
    end
  end
end
