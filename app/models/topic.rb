class Topic < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :conversations

  attr_accessible :name

  validates_presence_of :name
end
