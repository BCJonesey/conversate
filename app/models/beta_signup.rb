class BetaSignup < ActiveRecord::Base
  attr_accessible :email

  def create_promoted_user
    password = garbage_password
    user = User.build({
      email: self.email,
      password: password,
      password_confirmation: password,
      invite_count: 5
    })

    # This is kind of a strange line, but User::build will return a falsey
    # object if it fails, so we have to honor that.
    return user unless user

    support_contact = user.default_contact_list.contacts.build
    support_contact.user_id = User.support_user_id
    support_contact.save
    return user
  end

  private

  def garbage_password
    SecureRandom.uuid
  end
end
