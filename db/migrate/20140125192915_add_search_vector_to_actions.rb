class AddSearchVectorToActions < ActiveRecord::Migration
  def change
    add_column :actions, :search_vector, :tsvector
    add_index :actions, :search_vector, using: :gin
  end
end
