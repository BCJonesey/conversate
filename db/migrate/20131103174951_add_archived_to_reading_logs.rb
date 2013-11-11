class AddArchivedToReadingLogs < ActiveRecord::Migration
  def change
    add_column :reading_logs, :archived, :boolean, :default => false
  end
end
