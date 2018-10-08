class ConversationsController < ApplicationController
	before_action :validate_token, only: [:index, :create, :mark_read, :archive, :show]
	before_action :validate_message_params, only: :create

	def index
		@conversations = @current_user.conversations.includes(conversation_users: :user, messages: [:readers])
	end

	def create
		params[:conversation].merge!(conversation_users_attributes: [{}])
		params[:conversation][:conversation_users_attributes][0].merge!(is_creator: true, user_id: @current_user.id)
		@conversation = @current_user.conversations.build(conversation_params)
		if @conversation.save!
			params[:users].present? && params[:users].each do |user_id|
				@conversation.add_user(user_id)
			end
			render 'create.json'
		else
			render(json: {ok: false, error: @conversation.errors.full_messages, status: 401}, status: 401)
		end				
	end

	def show
		@conversations = []
		@conversations << Conversation.includes(conversation_users: :user, messages: [:readers]).find(params[:id].to_i)
		render 'archive'
	end

	def mark_read
		conversation_user = @current_user.conversation_users.find_by_conversation_id(params[:conversation_id])
		if conversation_user.present? 
			conversation_user.update_attributes(is_read: true)
			conversation_user.conversation.messages.map{ |c| c.readers.find_or_create_by!(user_id: @current_user.id)} if conversation_user.conversation.messages.present?
			render(json: {ok: true }, status: 200)
		else
			render(json: {ok: false, error: "Not Found" }, status: 404)
		end
	end

	def archive
		@conversation_users = ConversationUser.where('user_id = ? AND conversation_id = ?', @current_user.id, params[:conversation_id])
		if @conversation_users.present? && @conversation_users.try(:first).archive!
			@conversations = []
			@conversations << @conversation_users.first.conversation
			render 'archive', status: 200
		else
			render(json: {ok: false, error: "Not Found"}, status: 404)
		end
	end

	private
	def conversation_params
		params.require(:conversation).permit(:title, conversation_users_attributes: [:id, :user_id, :conversation_id, :is_creator, '_destroy'])
	end

	def validate_message_params
		@error_message = []
		@error_message << "Users must be present." if !params[:users].present?
		if @error_message.present?
			render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
		end
	end
end
