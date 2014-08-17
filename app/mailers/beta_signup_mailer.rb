class BetaSignupMailer < ActionMailer::Base
  default from: "Water Cooler Support <watercooler@structur.al>"

  def beta_signup_email(beta_signup)
    mail(to: beta_signup.email, subject: 'Thanks for signing up for Water Cooler')
  end
end
