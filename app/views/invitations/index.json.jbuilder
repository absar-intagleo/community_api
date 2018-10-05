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
      json.from_user do
        json.id invitation.user.id
        json.first_name invitation.user.first_name
        json.last_name invitation.user.last_name
        json.email invitation.user.email
        json.uuid invitation.user.uuid
        json.absolute_url invitation.user.absolute_url
        json.avatar invitation.user.avatar
        json.avatar_thumbnail invitation.user.avatar_thumbnail
        json.cover invitation.user.cover
        json.cover_cropped invitation.user.cover_cropped
      end
    end
  end
else
  json.error "You have no pending invitation"
end

