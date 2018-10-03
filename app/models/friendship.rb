class Friendship < ApplicationRecord
	belongs_to :user
  belongs_to :friend, :class_name => 'User'

  scope :invites_of_user, -> (current_user_id){ where('status = ? AND friend_id = ?', 1, current_user_id) }
  scope :approved, -> { where('status = ?', 2) }
  
end
