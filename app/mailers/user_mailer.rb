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
    mail(:to => user.email,
      :subject => 'Water Cooler: Welcome to the Beta',
      :template_name => :activation_web_email)
  end

  def activation_success_email(user)
    @user = user
    @url = root_url
    mail(:to => user.email,
         :subject => 'Water Cooler: Welcome to Water Cooler')
  end

  def activation_invite_email(invite)
    @url = edit_account_activation_url(invite.user.activation_token)
    @inviter = invite.inviter.full_name
    mail(:to => invite.user.email,
       :subject => "You've been invited to Watercooler.io!",
       :template_name => :activation_invite_email)
  end

end
