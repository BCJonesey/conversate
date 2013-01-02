class AddIdToReadingLog < ActiveRecord::Migration
  def change
    add_column :reading_logs, :id, :primary_key
  end
end
