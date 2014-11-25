class AddDescriptionToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :description, :string, :default => 'Unknown Device'
  end
end
