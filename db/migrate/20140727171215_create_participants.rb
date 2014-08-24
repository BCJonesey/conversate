class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :participatable, polymorphic: true
      t.references :user
      t.timestamps
    end
  end
end
