class User < ApplicationRecord
	has_many :friendships
  has_many :friends, :through => :friendships
  
  has_many :messages

  has_many :conversation_users
  has_many :conversations, through: :conversation_users

  has_many :readers
  has_many :messages, through: :readers


  scope :except_current_user, -> (current_user_id) { where.not(id: current_user_id) }
  scope :with_same_community, -> (current_community_id) { where(community_id: current_community_id) }
end
