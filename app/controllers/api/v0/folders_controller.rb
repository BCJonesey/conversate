class Api::V0::FoldersController < ApplicationController
  before_filter :require_login

  def index
    render :json => current_user.folders.includes(:conversations).to_json(:user => current_user)
  end

  def create
    folder = Folder.create(:name => params[:name])
    current_user.folders << folder
    current_user.save
    render :json => folder.to_json(:user => current_user), :status => 201
  end

  def update
    folder = Folder.find(params[:id])

    params[:users].map!{|x| User.find(x[:id])}
    params[:users] = params[:users].to_set
    existingUsers = folder.users.to_set

    folder.remove_users((existingUsers-params[:users]).to_a,current_user)
    folder.add_users((params[:users]-existingUsers).to_a,current_user)

    if folder.update_attributes(params[:folder])
      head :ok
    else
      render json: folder.errors, status: :unprocessable_entity
    end
  end

  def users
    folder = Folder.find(params[:id])
    binding.pry
    folder.add_users(params[:added].map { |e|  User.find(e[:id])},current_user)
    folder.remove_users(params[:removed].map { |e|  User.find(e[:id])},current_user)
    format.json { head :ok }
  end
end
