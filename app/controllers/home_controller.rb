class HomeController < ApplicationController
  def index
    if logged_in?
      redirect_to(conversations_path)
    else
      render 'sessions/new'
    end
  end
end
