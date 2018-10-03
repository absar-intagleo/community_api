json.ok true
json.status 200
if @invitations.present?
  json.results do
    json.array! @invitations.present? && @invitations.each do |invitation|
      json.id invitation.id 
      json.message invitation.message
      json.status  invitation.status == 1 ? "pending" : "approved"
      json.created_at invitation.created_at
      json.updated_at invitation.updated_at
      json.to_user do
        json.id invitation.friend.id
        json.first_name invitation.friend.first_name
        json.last_name invitation.friend.last_name
        json.email invitation.friend.email
        json.uuid invitation.friend.uuid
        json.absolute_url invitation.friend.absolute_url
        json.avatar invitation.friend.avatar
        json.avatar_thumbnail invitation.friend.avatar_thumbnail
        json.cover invitation.friend.cover
        json.cover_cropped invitation.friend.cover_cropped
      end
    end
  end
else
  json.error "You have no pending invitation"
end

