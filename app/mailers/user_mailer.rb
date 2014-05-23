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
         :subject => 'Water Cooler: Welcome to the Beta')
  end

  def activation_success_email(user)
    @user = user
    @url = root_url
    mail(:to => user.email,
         :subject => 'Water Cooler: Welcome to Water Cooler')
  end
end
