class TestbedController < ApplicationController
  before_filter :require_login
  before_filter :require_admin

  def index
    @views = [
      'conversation'
    ]
  end

  def test_view
    @view_name = params[:view]
  end
end
