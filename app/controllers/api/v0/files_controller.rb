class Api::V0::FilesController < ApplicationController
  before_filter :require_login_api

  def create
    puts 'FILE UPLOAD'
    render :json => {}
  end

end
