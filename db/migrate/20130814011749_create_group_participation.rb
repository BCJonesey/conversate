class CreateGroupParticipation < ActiveRecord::Migration
  def up
    create_table :group_participations do |t|
      t.integer :group_id
      t.integer :user_id
      t.boolean :group_admin
    end
  end

  def down
    drop_table :group_participation
  end
end
