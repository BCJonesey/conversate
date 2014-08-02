class Invite < ActiveRecord::Base
  attr_accessible :email, :user_id, :inviter_id
  validates :email, presence: true, format: /@/
  validates :user_id, presence: true, numericality: {:only_integer => true}
  validates :inviter_id, presence: true, numericality: {:only_integer => true}
end
