class BetaSignup < ActiveRecord::Base
  attr_accessible :email

  def create_promoted_user
    password = garbage_password
    User.build({
      email: self.email,
      password: password,
      password_confirmation: password
    })
  end

  private

  def garbage_password
    SecureRandom.uuid
  end
end
