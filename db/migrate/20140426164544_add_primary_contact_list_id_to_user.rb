class AddPrimaryContactListIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_contact_list_id, :integer
  end
end
