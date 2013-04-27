class ChangeEventTypeToType < ActiveRecord::Migration
  def up
    change_table :actions do |t|
      t.rename :event_type, :type
    end
  end

  def down
    change_table :actions do |t|
      t.rename :type, :event_type
    end
  end
end
