class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :reading_logs
  has_many :conversations, :through => :reading_logs
  has_many :events, :inverse_of => :user

  attr_accessible :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def name
    full_name || email
  end

  def mark_as_read(conversation)
    if conversation.events.length > 0
      reading_log = conversation.reading_logs.where({:user_id => self.id}).first
      reading_log.last_read_event = conversation.events.order('created_at DESC').first.id
      reading_log.save!
    end
  end
end
