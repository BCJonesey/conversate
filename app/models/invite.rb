class Invite < ActiveRecord::Base
  attr_accessible :user_id, :inviter_id
  validates :user_id, presence: true, numericality: {:only_integer => true}, uniqueness: { scope: :inviter_id, message: "A user can only invite a specfic person once" }
  validates :inviter_id, presence: true, numericality: {:only_integer => true}

  belongs_to :user
  belongs_to :inviter, class_name: "User"

  # Builds an invite.
  # Params:
  # inviter: User object that is creating and invitation
  # invitee_email: The email addy of the person getting invited.
  def self.build(params)
    invite = Invite.new()

    inviter = params[:inviter]

    # Users must have invites left.
    invite.errors.add(:inviter, "Inviter does not have any invites left") and return invite unless inviter.invite_count > 0

    invite.inviter_id = inviter.id

    invitee_email = params[:invitee_email]

    # Find the invited user if they exist
    user = User.find_by_email(invitee_email)

    # Let's create a new user for this invite if we need to.
    if user.nil?
      user = User.build(:email => invitee_email,
                        :password => SecureRandom.uuid,
                        :creation_source => :invite)
      support_contact = user.default_contact_list.contacts.build
      support_contact.user_id = User.support_user_id
      support_contact.save
    end

    invite.errors.add(:user, "User could not be found or created")  and return invite unless user

    invite.user = user

    return invite unless invite.save

    begin
      UserMailer.activation_invite_email(invite).deliver
    rescue
      invite.destroy!
      invite.errors.add(:user, "Could not send invitation email") and return invite
    end



    # Once we sucessfully added an invitation, add the inviter to the invitee's contact list, and vice-versa
    contact = user.default_contact_list.contacts.build()
    contact.user = inviter
    contact.save

    contact = inviter.default_contact_list.contacts.build()
    contact.user = user
    contact.save

    # If we've successfully sent an email, we want to remove one of the user's invites.
    inviter.invite_count -= 1
    inviter.save

    invite
  end

end
