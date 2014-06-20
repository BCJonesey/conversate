class UserMailer < ActionMailer::Base
  default from: "noreply@watercooler.io"

  # app/mailers/user_mailer.rb
  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(:to => user.email,
         :subject => "Your password has been reset")
  end

  def send_invite(email)
    mail(:to => email,
      :subject => "Welcome to Watercooler!")
  end
end
