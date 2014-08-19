require 'active_support/core_ext'

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

  attr_accessible :email, :full_name, :password, :password_confirmation, :external, :creation_source, :invite_count

  validates_confirmation_of :password
  # We have to allow nil passwords or we wouldn't ever be able to change a
  # user record.  The database doesn't actually have a password field (just the
  # encrypted password) so unless we set it explicitly (which would change it)
  # it's always nil.
  validates :password, length: { minimum: 1 }, allow_nil: true
  validates_presence_of :password, :on => :create, :unless => :external
  validates :email, presence: true , format: /@/
  validates_uniqueness_of :email, :case_sensitive => false

  SUPPORT_USER_ID = 122
  # Apparently I can't define a static constant?  I Have to def it?
  def self.support_user_id
    SUPPORT_USER_ID
  end

  def self.build(params)
    user = User.new(params)
    return false if user.save == false
    # Apparently save will helpfully nil out the password field and then
    # complain that the password confirmation field doesn't match.
    user.password_confirmation = nil

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
    full_name.nil? || full_name.empty? ? email : full_name
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

  def create_welcome_conversation()
    support = User.find(SUPPORT_USER_ID)
    welcome_convo = self.default_folder.conversations.create(title: "Hi #{self.name}, welcome to Water Cooler")
    action_params = [
      { 'type' => 'retitle',
        'title' => "Hi #{self.name}, welcome to Water Cooler"
        },
        { 'type' => 'update_users',
          'added' => [{id: support.id, full_name: support.full_name},
            {id: self.id, full_name: self.full_name, email: self.email}],
            'removed' => nil
            },
            { 'type' => 'message',
              'text' => <<-EOS.strip_heredoc
              Hi #{self.name}, Welcome to Water Cooler.

              If you have any questions, you can reply to this message and someone from the Water Cooler will get back to you as soon as we can.

              If you're ever having trouble with Water Cooler, you can send an old fashioned email to watercooler@structur.al and we'll try to help you out.

              Thanks,

              -The Water Cooler Team

              P.S.  If you're using chrome, we have a little notifier extension to let you know when you have unread Water Cooler messages.

              https://chrome.google.com/webstore/detail/watercooler/iojmggbopjbgmkhceojpkdlkjndpfpbb
              EOS
            }
          ]
          action_params.each do |params|
            action = welcome_convo.actions.create({
              type: params['type'],
              data: Action.data_for_params(params),
              user_id: support.id
              })
            action.save
            welcome_convo.handle(action)
          end
          welcome_convo.most_recent_event = welcome_convo.actions.last.created_at
          welcome_convo.save
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
