class Api::V0::SearchController < ApplicationController
  before_filter :require_login_api

  def index
    results = SearchResult.actions(params[:query], current_user)
    render :json => {'query' => params[:query], 'results' => results}
  end
end
