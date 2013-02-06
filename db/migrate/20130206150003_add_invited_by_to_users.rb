class AddInvitedByToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :invited_by
    end
  end
end
