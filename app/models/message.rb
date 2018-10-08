class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  has_many :readers, dependent: :destroy
  has_many :users, through: :readers
  has_one_attached :attachment, dependent: :destroy

  
  after_create :mark_conversation_as_unread_for_all_other_users

  scope :except_current_user, -> (current_user_id) { where.not(id: current_user_id) }

  def mark_conversation_as_unread_for_all_other_users
  	self.conversation.conversation_users.where.not(user_id: self.user_id).update_all(is_read: false)
  end

  def mark_conversation_as_read_for_current_user
  	self.conversation.conversation_users.where(user_id: self.user_id).update_all(is_read: true)
  end
end
