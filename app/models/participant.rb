class Participant < ActiveRecord::Base
  belongs_to :participatable, polymorphic: true
  belongs_to :user
end
