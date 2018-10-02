json.ok true
json.status 200
json.id @message.id
json.conversation @message.conversation_id 
json.text @message.text 
json.attachment @message.attachment.attachment.present? ? request.base_url + url_for(@message.attachment) :nil
json.created_at @message.created_at
json.updated_at @message.updated_at
json.read_by []
json.user do
  json.id @message.user.id
  json.first_name @message.user.first_name
  json.last_name @message.user.last_name
  json.email @message.user.email
  json.uuid @message.user.uuid
  json.absolute_url @message.user.absolute_url
  json.avatar @message.user.avatar
  json.avatar_thumbnail @message.user.avatar_thumbnail
  json.cover @message.user.cover
  json.cover_cropped @message.user.cover_cropped
end