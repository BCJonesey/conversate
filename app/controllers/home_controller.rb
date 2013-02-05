class HomeController < ApplicationController
  def index
    redirect_to(conversations_path) if logged_in?
    render 'sessions/new'
  end
end
