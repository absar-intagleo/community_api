json.ok true
json.status 200
json.id @conversation.id
json.title @conversation.title
json.archived_by @conversation.conversation_users.has_archived.map(&:user_id)
json.last_message @conversation.messages.try(:last)
json.read_by []
json.absolute_url @conversation.absolute_url
json.created_at @conversation.created_at
json.updated_at @conversation.updated_at

json.users do
	json.array! @conversation.conversation_users.except_creator.each do |conversation_user|
		json.id conversation_user.user.id
		json.first_name conversation_user.user.first_name
		json.last_name conversation_user.user.last_name
		json.email conversation_user.user.email
		json.uuid conversation_user.user.uuid
		json.absolute_url conversation_user.user.absolute_url
		json.avatar conversation_user.user.avatar
		json.avatar_thumbnail conversation_user.user.avatar_thumbnail
		json.cover  conversation_user.user.cover
		json.cover_cropped  conversation_user.user.cover_cropped
	end
end

json.creator do 
	creator = @conversation.conversation_users.only_creator.first.user
	json.id creator.id
	json.first_name creator.first_name
	json.last_name creator.last_name
	json.email creator.email
	json.uuid creator.uuid
	json.absolute_url creator.absolute_url
	json.avatar creator.avatar
	json.avatar_thumbnail creator.avatar_thumbnail
	json.cover  creator.cover
	json.cover_cropped  creator.cover_cropped
end