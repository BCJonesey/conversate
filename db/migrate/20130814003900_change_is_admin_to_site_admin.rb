class ChangeIsAdminToSiteAdmin < ActiveRecord::Migration
  def up
    rename_column :users, :is_admin, :site_admin
  end

  def down
    rename_column :users, :site_admin, :is_admin
  end
end
