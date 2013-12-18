class AddSendMeMailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_me_mail, :boolean, :default => false
  end
end
