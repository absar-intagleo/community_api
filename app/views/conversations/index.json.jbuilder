json.ok true
json.count @conversations.try(:count)
json.results do
  json.array! @conversations.present? && @conversations.each do |conversation|
    json.id conversation.id
    if conversation.users.present?
      json.users do
        json.array! conversation.user.each do |user|
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
    else
      json.users []
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
    json.last_message do
      message = conversation.messages.last
      if message.present?
        json.id message.id
        json.user do
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
        json.conversation message.conversation.id
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
              json.date reader.created_at
            end  
          end
        else
          json.read_by []
        end
      end
    end
    json.created_at conversation.created_at
    json.updated_at conversation.updated_at
    if conversation.conversation_users.present? && conversation.conversation_users.has_archived.present?
      json.archived_by do
        json.array! conversation.conversation_users.has_archived.each do |conversation_user|
          json.user do
            archived_by_user = conversation_user.user
            json.id archived_by_user.id
            json.first_name archived_by_user.first_name
            json.last_name archived_by_user.last_name
            json.username archived_by_user.username
            json.uuid archived_by_user.uuid
            json.email archived_by_user.email
            json.absolute_url archived_by_user.absolute_url
            json.avatar archived_by_user.avatar
            json.cover archived_by_user.cover
          end
          json.date conversation_user.archived_at
        end
      end
    else
      json.archived_by []
    end
    if (conversation.conversation_users.present? && conversation.conversation_users.read_by.count > 0 )
      json.read_by do      
        json.array! conversation.conversation_users.read_by.each do |conversation_user|
          json.user do
            read_by_user = conversation_user.user
            json.id read_by_user.id
            json.first_name read_by_user.first_name
            json.last_name read_by_user.last_name
            json.username read_by_user.username
            json.uuid read_by_user.uuid
            json.email read_by_user.email
            json.absolute_url read_by_user.absolute_url
            json.avatar read_by_user.avatar
            json.cover read_by_user.cover
          end
          json.date conversation_user.updated_at
        end  
      end
    else
      json.read_by []
    end
  end
end