class AddPinnedBooleanToReadingLogs < ActiveRecord::Migration
  def change
    add_column :reading_logs, :pinned, :boolean, default: false
  end
end
