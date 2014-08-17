class AddCreationSourceToUser < ActiveRecord::Migration
  def change
    add_column :users, :creation_source, :string, :default => :web
  end
end
