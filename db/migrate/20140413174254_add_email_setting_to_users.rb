class AddEmailSettingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_setting, :string, :default => 'never'
  end
end
