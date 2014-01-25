class Api::V0::SearchController < ApplicationController
  before_filter :require_login_api

  def index
    render :json => SearchResult.actions(params[:query])
  end
end
