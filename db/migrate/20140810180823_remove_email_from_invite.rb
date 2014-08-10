class RemoveEmailFromInvite < ActiveRecord::Migration
  def change
    remove_column :invites, :email, :string
  end
end
