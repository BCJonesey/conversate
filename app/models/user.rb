class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :reading_logs
  has_many :conversations, :through => :reading_logs
  has_many :actions, :inverse_of => :user
  has_many :group_participations
  has_many :groups, :through => :group_participations
  has_many :contacts
  has_and_belongs_to_many :folders
  belongs_to :default_folder, class_name: "Folder", foreign_key: "default_folder_id"

  attr_accessible :email, :full_name, :password, :password_confirmation, :external

  validates_confirmation_of :password
  # We have to allow nil passwords or we wouldn't ever be able to change a
  # user record.  The database doesn't actually have a password field (just the
  # encrypted password) so unless we set it explicitly (which would change it)
  # it's always nil.
  validates :password, length: { minimum: 1 }, allow_nil: true
  validates_presence_of :password, :on => :create, :unless => :external
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false

  def self.build(params)
    user = User.new(params)
    return false if user.save == false

    new_contact_list = ContactList.new

    new_contact_list.name = "My Contact List"
    new_contact_list.save
    user.default_contact_list_id = new_contact_list.id

    # External users have no purpose other than to receive mail.
    user.send_me_mail = true if user.external

    new_folder = Folder.new
    new_folder.name = 'Inbox'
    new_folder.users << user
    new_folder.save
    user.default_folder_id = new_folder.id
    user.save

    user
  end

  def self.find_by_email_insensitive(email)
    User.where('lower(email) = ?', email.downcase).first
  end

  def name
    full_name.empty? ? email : full_name
  end

  def update_most_recent_viewed(conversation)
    log = self.reading_logs.where(:conversation_id => conversation.id).first
    log.most_recent_viewed = Time.now.to_datetime
    log.save!
  end

  def unread_count
    self.reading_logs.where("unread_count >0").count
  end

  def unread_conversations
    conversations.find(self.reading_logs.where("unread_count >0").pluck(:conversation_id))
  end

  def known_contacts
    self.contact_lists.map{ |g| g.contacts }.flatten
  end

  def group_admin?(group)
    self.group_participations.where(group_id: group.id).first.group_admin
  end

  def ensure_cnv_in_at_least_one_folder(conversation)
    if (conversation.folders.to_set & self.folders.to_set).empty?
      conversation.folders << self.default_folder
    end
  end

  def contact_lists
    self.default_contact_list ? [self.default_contact_list] : []
  end

  def default_contact_list
    self.default_contact_list_id.nil? ? nil : ContactList.find(self.default_contact_list_id)
  end

  # This avoids us writing out passwords, salts, etc. when rendering json.
  def as_json(options={})
    json = super(:only => [:email, :full_name, :id, :site_admin, :external])
    if options[:conversation]
      json['most_recent_viewed'] = options[:conversation].most_recent_viewed_for_user(self).msec
    end

    return json
  end

  def debug_s
    "User:#{self.id}:#{self.name}"
  end
end
