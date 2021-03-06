if @messages.present?
	json.ok true
	json.id params[:conversation_id]
	if @messages.present?
		json.results do
			json.array! @messages.each do |message|
				json.id message.id
				json.conversation message.conversation_id 
				json.text message.text 
				json.attachment message.attachment.attachment.present? ? request.base_url + url_for(message.attachment) :nil
				json.created_at message.created_at
				json.updated_at message.updated_at
				if message.readers.present?
					json.read_by do
						json.array! message.readers.each do |reader|
		          user = reader.user
		          json.user do
		            json.id user.id
		            json.first_name user.first_name
		            json.last_name user.last_name
		            json.username user.username
		            json.uuid user.uuid
		            json.email user.email
		            json.absolute_url user.absolute_url
		            json.avatar user.avatar
		            json.cover user.cover
		          end
		          json.readby_date reader.created_at
		        end
					end
				else
					json.read_by []
				end
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
		json.ok true
		json.id params[:conversation_id]
		json.results []
	end
else
  json.ok true
	json.id params[:conversation_id]
	json.results []
end