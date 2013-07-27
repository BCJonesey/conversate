class AddDefaultTopicIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_topic_id, :integer
  end
end
