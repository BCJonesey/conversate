class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_and_belongs_to_many :conversations
  has_many :events, :inverse_of => :user

  attr_accessible :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
end
