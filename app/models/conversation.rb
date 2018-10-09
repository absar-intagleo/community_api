class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  accepts_nested_attributes_for :conversation_users, :allow_destroy => true
  
  has_many :users, through: :conversation_users

  has_many :messages, dependent: :destroy


  def add_user(user_id)
  	self.conversation_users.create(:user_id => user_id)
  end

  def self.only_unarchived_conversations(conversations, user_id)
  	
  	un_archived_conversations = []
  	conversations.present? && conversations.each do |conversation|
  		un_archived_conversations << conversation if conversation.conversation_users.where(user_id: user_id).where.not(archived_at: nil).blank?
  	end
  	un_archived_conversations
  end
end
