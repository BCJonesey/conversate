class Participant < ActiveRecord::Base
  belongs_to :participatable, polymorphic: true
  belongs_to :user
  attr_accessible :user_id
  validates :user_id, :presence => true, :uniqueness => {:scope => [:participatable_id,:participatable_type]}
  validates :participatable_id, :presence => true

end
