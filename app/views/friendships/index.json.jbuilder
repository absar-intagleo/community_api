json.ok true
json.count @friends.present? ? @friends.count : 0
json.results do
  if @friends.present?  
	json.array! @friends.each do |friend|
    user = if friend.user.id == @current_user.id
  		friend.friend
    elsif friend.friend.id == @current_user.id
      friend.user
    end
    json.id user.id
    json.first_name user.first_name
    json.last_name user.last_name
    json.username user.username
    json.uuid user.uuid
    json.email user.email
    json.absolute_url user.absolute_url
    json.avatar user.avatar
    json.cover user.cover
    json.created_at friend.created_at
	end
  else
    json.array! []
  end
end