require 'spec_helper'

describe HomeController do
  before(:all) do
    BetaSignup.delete_all
  end

  describe 'POST #beta_signup' do
    it 'creates a beta signup user and emails them' do
      expect(BetaSignup.all.pluck(:email)).not_to include('wcbeta@example.com')
      delivery_count = BetaSignupMailer.deliveries.count

      post :beta_signup, email: 'wcbeta@example.com'

      expect(BetaSignup.all.pluck(:email)).to include('wcbeta@example.com')
      expect(BetaSignupMailer.deliveries.count).to eql(delivery_count + 1)
    end
  end
end
