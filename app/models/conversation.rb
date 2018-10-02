class Conversation < ApplicationRecord
	has_many :conversation_users, dependent: :destroy
  accepts_nested_attributes_for :conversation_users, :allow_destroy => true
  
  has_many :users, through: :conversation_users

  has_many :messages, dependent: :destroy


  def add_user(user_id)
  	self.conversation_users.create(:user_id => user_id)
  end
end
