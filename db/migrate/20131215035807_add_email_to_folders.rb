class AddEmailToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :email, :string
    add_index :folders, :email
  end
end
