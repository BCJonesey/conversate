class DeleteAllTopics < ActiveRecord::Migration
  class Topic < ActiveRecord::Base
  end

  def up
    Topic.delete_all
  end

  def down
    # Sorry!
  end
end
