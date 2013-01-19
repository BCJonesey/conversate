class HomeController < ApplicationController
  def index
    redirect_to(conversations_path) if logged_in?
  end
end
