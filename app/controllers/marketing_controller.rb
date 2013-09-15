class MarketingController < ApplicationController
  before_filter :require_speakeasy

  def index
  end

  def tour
  end

  def pricing
  end

  private

  def require_speakeasy
    redirect_to root_url unless session[:code_word] == SpeakeasyCode
  end
end