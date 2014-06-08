class Invite < ActiveRecord::Base
  attr_accessor :email, :user_id
  validates :email, presence: true, format: /@/
  validates :user_id, presence: true, numericality: {:only_integer => true}
end
