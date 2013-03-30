class TestbedController < ApplicationController
  before_filter :require_login
  before_filter :require_admin

  def index
    @views = [
      'conversation',
      'conversation-list',
      'conversation-container'
    ]
  end

  def test_view
    @view_name = params[:view]
  end
end
