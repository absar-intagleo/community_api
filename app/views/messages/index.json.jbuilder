if @messages.present?
	json.ok true
	json.id params[:conversation_id]
	json.results do
		json.array! @messages.present? && @messages.each do |message|
			json.id message.id
			json.conversation message.conversation_id 
			json.text message.text 
			json.attachment message.attachment.attachment.present? ? request.base_url + url_for(message.attachment) :nil
			json.created_at message.created_at
			json.updated_at message.updated_at
			json.read_by message.readers.map(&:user_id)
			json.user do
				message_user = message.user
			  json.id message_user.id
			  json.first_name message_user.first_name
			  json.last_name message_user.last_name
			  json.email message_user.email
			  json.uuid message_user.uuid
			  json.absolute_url message_user.absolute_url
			  json.avatar message_user.avatar
			  json.avatar_thumbnail message_user.avatar_thumbnail
			  json.cover message_user.cover
			  json.cover_cropped message_user.cover_cropped
			end
		end
end
else
  json.ok false
  json.status 404
  json.detail "Not Found"
end