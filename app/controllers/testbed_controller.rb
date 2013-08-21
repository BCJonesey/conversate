class TestbedController < ApplicationController
  before_filter :require_login
  before_filter :require_site_admin

  def index
    @views = [
      'conversation',
      'conversation-list',
      'conversation-container',
      'topic',
      'topic-list',
      'topic-container',
      'title-editor',
      'participant-editor',
      'action',
      'action-list',
      'compose',
      'action-container',
      'structural-bar',
      'the-whole-app'
    ]
  end

  def test_view
    @view_name = params[:view]
  end
end
