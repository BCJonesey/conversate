class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contact_lists do |t|
      t.string :name
      t.timestamps
    end
    create_table :contacts do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :contact_list, :null => false

      t.timestamps
    end
  end
end
