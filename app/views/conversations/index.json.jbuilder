json.ok true
json.results do
  json.array! @conversations.present? && @conversations.each do |conversation|
    json.id conversation.id
    json.users do
      json.array! conversation.users.each do |user|
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
    end
    json.title conversation.title
    json.creator do
      creator = conversation.conversation_users.find_by(is_creator: true).user
      json.id creator.id
      json.first_name creator.first_name
      json.last_name creator.last_name
      json.username creator.username
      json.uuid creator.uuid
      json.email creator.email
      json.absolute_url creator.absolute_url
      json.avatar creator.avatar
      json.cover creator.cover
    end
    json.archived_by conversation.conversation_users.has_archived.map(&:user_id)
    json.last_message do
      message = conversation.messages.last
      if message.present?
        json.id message.id
        json.users do
          message_user = message.user
          json.id message_user.id
          json.first_name message_user.first_name
          json.last_name message_user.last_name
          json.username message_user.username
          json.uuid message_user.uuid
          json.email message_user.email
          json.absolute_url message_user.absolute_url
          json.avatar message_user.avatar
          json.cover message_user.cover
        end
        json.conversation_id message.conversation.id
        json.text message.text
        json.attachment message.attachment.attachment.present? ? request.base_url + url_for(message.attachment) :nil
        json.created_at message.created_at
        json.updated_at message.updated_at
        json.read_by message.readers.map(&:user_id)
      end
    end
    json.created_at conversation.created_at
    json.updated_at conversation.updated_at
    json.read_by conversation.conversation_users.read_by.map(&:user_id)
  end
end