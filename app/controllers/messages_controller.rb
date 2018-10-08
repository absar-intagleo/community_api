class MessagesController < ApplicationController
	before_action :validate_token, only: [:index, :create, :mark_read, :delete]
	before_action :validate_message_params, only: :create

	def index
		@messages = Conversation.includes(messages: [:readers, :user]).find(params[:conversation_id]).try(:messages) rescue nil
		render 'index.json', status: @messages.present? ? 200 : 404
	end

	def create
		@message = Message.new(conversation_id: params[:conversation_id], text: params[:text], user_id: @current_user.id)
		@message.attachment.attach(params[:attachment]) if params[:attachment].present?
		if @message.save!
			render 'create.json'
		else
			render(json: {ok: false, error: @message.errors.full_messages, status: 401}, status: 404)
		end		
	end

	def mark_read
		@message = Message.find(params[:message_id])
		if @message.present?
			if @message.readers.find_or_create_by!(user_id: @current_user.id, message_id: @message.id)
				render(json: {ok: true }, status: 200)
			else
				render(json: {ok: false }, status: 401)
			end
		else
			render(json: {ok: false }, status: 401)
		end
	end

	def delete
		@messages = Message.where('id IN (?)',  params[:message_ids].gsub!("[", "").gsub!("]", "").split(",").map(&:to_i))
		if @messages.present? && @messages.destroy_all
			render(json: {success: true}, status: 200)
		else
			render(json: {ok: false, error: "Message not found"}, status: 401)
		end
	end

	private
	def validate_message_params
		@error_message = []
		@error_message << "conversation_id must be present." unless params[:conversation_id].present?
		@error_message << "text or attachment must be present." if params[:text].blank? && params[:attachment].blank?

		if @error_message.present?
			render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
		end
	end

	def validate_delete_params
		@error_message << "message_ids must be present." if params[:message_ids].blank?

		if @error_message.present?
			render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
		end
	end
end
