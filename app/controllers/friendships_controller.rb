class FriendshipsController < ApplicationController
	before_action :validate_token, only: :index

	def index
		@friends = @current_user.friendships.try(:approved)
		render "index.json"
	end
end

