class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :reading_logs
  has_many :conversations, :through => :reading_logs
  has_many :events, :inverse_of => :user
  has_and_belongs_to_many :topics

  attr_accessible :email, :full_name, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def self.build(params)
    user = User.new(params)
    return false if user.save == false

    default_topic = Topic.new
    default_topic.name = 'My Conversations'
    default_topic.users << user
    default_topic.save
    user.default_topic_id = default_topic.id
    user.save

    user
  end

  def name
    full_name || email
  end

  def update_most_recent_viewed(conversation)
    log = self.reading_logs.where(:conversation_id => conversation.id).first
    log.most_recent_viewed = Time.now.to_datetime
    log.save!
  end

  def unread_count
    self.conversations.keep_if {|c| c.unread_for?(self) }.length
  end

  # Public: returns the users this user knows.
  # Note - currently everyone is assumed to know everyone else.  Fix this at
  # some future date.
  def address_book
    users = User.all - [self]
    address_book = Array.new
    users.map do |user|
      addressee = Hash.new
      addressee['id'] = user.id
      addressee['full_name'] = user.full_name
      addressee['email'] = user.email
      address_book.push(addressee)
    end
    return address_book
  end

  # This avoids us writing out passwords, salts, etc. when rendering json.
  def as_json(options={})
    json = super(:only => [:email, :full_name, :id, :site_admin])
    json['address_book'] = address_book

    if options[:conversation]
      json['most_recent_viewed'] = options[:conversation].most_recent_viewed_for_user(self).msec
    end

    return json
  end
end
