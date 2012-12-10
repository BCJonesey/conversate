class RenameSubjectToTitle < ActiveRecord::Migration
  def up
    change_table :conversations do |t|
      t.rename :subject, :title
    end
  end

  def down
    change_table :conversations do |t|
      t.rename :title, :subject
    end
  end
end
