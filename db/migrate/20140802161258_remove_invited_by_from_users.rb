class RemoveInvitedByFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :invited_by, :integer
  end
end
