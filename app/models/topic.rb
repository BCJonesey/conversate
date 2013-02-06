class Topic < ActiveRecord::Base
  has_many :reading_logs
  has_many :users, :through => :reading_logs
  has_many :conversations, :through => :reading_logs

  attr_accessible :name

  validates_presence_of :name
end
