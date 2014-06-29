class UserMailer < ActionMailer::Base
  default from: "noreply@watercooler.io"

  # app/mailers/user_mailer.rb
  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(:to => user.email,
         :subject => "Your password has been reset")
  end

  def activation_needed_email(user)
    @user = user
    case user.creation_source
    when :invite
      activation_invite_email(user)
    else
      activation_web_email(user)
    end
  end

  def activation_success_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/login"
    mail(:to => user.email,
         :subject => "Your account is now activated")
  end

  private

  def activation_invite_email(user)
    @url  = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"
    mail(:to => user.email,
       :subject => "You've been invited to Watercooler.io!",
       :template_name => :activation_invite_email)
  end

  def activation_web_email(user)
    @url  = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"
    mail(:to => user.email,
       :subject => "You've signed up for Watercooler.io!",
       :template_name => :activation_web_email)
  end

end
