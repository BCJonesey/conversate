class TestbedController < ApplicationController
  before_filter :require_login
  before_filter :require_admin

  def test_view
  end
end
