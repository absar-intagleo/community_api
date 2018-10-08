class FriendshipsController < ApplicationController
	before_action :validate_token, only: :index

	def index
		@friends = Friendship.where('user_id = ? OR friend_id = ?', @current_user.id, @current_user.id).try(:approved)
		render "index.json"
	end
end

