class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :reading_logs
  has_many :conversations, :through => :reading_logs
  has_many :actions, :inverse_of => :user
  has_many :group_participations
  has_many :groups, :through => :group_participations
  has_and_belongs_to_many :folders
  belongs_to :default_folder, class_name: "Folder", foreign_key: "default_folder_id"

  attr_accessible :email, :full_name, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def self.build(params)
    user = User.new(params)
    return false if user.save == false

    new_folder = Folder.new
    new_folder.name = 'My Conversations'
    new_folder.users << user
    new_folder.save
    user.default_folder_id = new_folder.id
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
  def address_book
    users = self.groups.map { |g| g.users }.flatten.uniq - [self]

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

  def group_admin?(group)
    self.group_participations.where(group_id: group.id).first.group_admin
  end

  def ensure_cnv_in_at_least_one_folder(conversation)
    if (conversation.folders.to_set & self.folders.to_set).empty?
      conversation.folders << self.default_folder
    end
  end

  # This avoids us writing out passwords, salts, etc. when rendering json.
  def as_json(options={})
    json = super(:only => [:email, :full_name, :id, :site_admin])
    if options[:include_address_book]
      json['address_book'] = address_book
    end

    if options[:conversation]
      json['most_recent_viewed'] = options[:conversation].most_recent_viewed_for_user(self).msec
    end

    return json
  end

  def debug_s
    "User:#{self.id}:#{self.name}"
  end
end
