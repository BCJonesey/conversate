class Api::V0::FilesController < ApplicationController
  before_filter :require_login_api

  def create
    render :json => {}
  end

end
