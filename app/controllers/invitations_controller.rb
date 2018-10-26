class InvitationsController < ApplicationController
	before_action :validate_token, only: [:index, :create, :accept]
	before_action :validate_invitation_params, only: :create
	before_action :validate_accept_params, only: :accept
	
	def index
		@invitations = @current_user.present? ? Friendship.where(friend_id: @current_user.id, status: 1) : nil
		render "index.json"
	end

	def create
		@invite = Friendship.where('(user_id = ? AND friend_id = ?) OR friend_id = ? AND user_id = ?', @current_user.id, params[:friend_id], @current_user.id, params[:friend_id])
		if @invite.present?
			render(json: {success: "false", error: "You are already friends"}, status: 404)
		else
			@invite = Friendship.find_or_create_by!(user_id: @current_user.id, friend_id: params[:friend_id], message: params[:message], status: 1)
			render('create.json', status: 200)
		end	
	end

	def accept
		@invitation = Friendship.where(user_id: params[:user_id], friend_id: @current_user.id).try(:first)
		if @invitation.present? && @invitation.status == 1
			@invitation.update_attributes(status: 2)
			render(json: {success: true}, status: 200)
		else
			render(json: {error: "Not found"}, status: 404)
		end
	end

	private

	def validate_accept_params
		@error_message = []
		@error_message << "user_id must be present." unless params[:user_id].present?

		if @error_message.present?
			render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
		end
	end
	def validate_invitation_params
		@error_message = []
		@error_message << "friend_id must be present." unless params[:friend_id].present?

		if @error_message.present?
			render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
		end
	end

end
