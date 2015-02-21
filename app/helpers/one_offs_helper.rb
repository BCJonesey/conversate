module OneOffsHelper
  def self.dedupe_beta_list
    unique_emails_by_count = BetaSignup.group(:email).count
    unique_emails_by_count.each do |email, count|
      if count > 1
        # Let's purge all of the duplicate signups except for one.
        while BetaSignup.where(:email => email).count > 1
          email_model = BetaSignup.find_by_email(email)
          email_model.destroy
        end
      end
    end
  end
end
