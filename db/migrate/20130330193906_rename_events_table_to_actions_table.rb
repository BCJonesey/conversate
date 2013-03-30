class RenameEventsTableToActionsTable < ActiveRecord::Migration
  def change
    rename_table :events, :actions
  end
end
