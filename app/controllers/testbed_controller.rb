class TestbedController < ApplicationController
  before_filter :require_login
  before_filter :require_admin

  def index
    @views = [
      'conversation',
      'conversation-list',
      'conversation-container',
      'topic',
      'topic-list',
      'topic-container',
      'action',
      'action-list',
      'action-container',
      'structural-bar',
      'the-whole-app'
    ]
  end

  def test_view
    @view_name = params[:view]
  end
end
