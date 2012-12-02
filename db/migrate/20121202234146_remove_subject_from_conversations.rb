class RemoveSubjectFromConversations < ActiveRecord::Migration
  def up
    change_table :conversations do |t|
      t.remove :subject
    end
  end

  def down
    change_table :conversations do |t|
      t.string :subject, :default => nil
    end
  end
end
