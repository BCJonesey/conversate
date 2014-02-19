class ChangeActionsDataColumnToJson < ActiveRecord::Migration
  def up
    execute "alter table actions alter column data type json using data::json"
  end

  def down
    change_column :actions, :data, :text
  end
end
