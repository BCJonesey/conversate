class UserMailer < ActionMailer::Base
  default from: "Water Cooler Support <watercooler@structur.al>"

  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(:to => user.email,
         :subject => "Water Cooler: Your password has been reset")
  end

  def activation_needed_email(user)
    @user = user
    @url = edit_account_activation_url(user.activation_token)
    case user.creation_source
    when :invite
      activation_invite_email(user)
    else
      activation_web_email(user)
    end
  end

  def activation_success_email(user)
    @user = user
    @url = root_url
    mail(:to => user.email,
         :subject => 'Water Cooler: Welcome to Water Cooler')
  end

  private

  def activation_invite_email(user)
    invite = Invite.where(:user_id => user.id).first
    inviter_user = User.find(invite.inviter_id)
    @inviter = inviter_user.full_name
    mail(:to => user.email,
       :subject => "You've been invited to Watercooler.io!",
       :template_name => :activation_invite_email)
  end

  def activation_web_email(user)
    mail(:to => user.email,
      :subject => 'Water Cooler: Welcome to the Beta',
      :template_name => :activation_web_email)
  end

end
