class AdminController < ApplicationController
  before_filter :require_site_admin

  def index
  end

  def promote
    redirect_to admin_path
  end
end
