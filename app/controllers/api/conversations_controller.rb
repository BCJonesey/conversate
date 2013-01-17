class Api::ConversationsController < ApplicationController

	def index
		render :json => user_conversations
	end

	private
  	def user_conversations
    	return current_user.conversations.order('updated_at DESC')
  	end
end
