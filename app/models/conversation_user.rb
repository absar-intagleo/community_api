class ConversationUser < ApplicationRecord
  acts_as_archival

  belongs_to :user
  belongs_to :conversation


  scope :has_archived, -> { where.not(archived_at: nil) }
  
  scope :except_creator, -> { where(is_creator: false) }
  scope :only_creator, -> { where(is_creator: true) }
  scope :read_by, -> { where(is_read: true) }
 
end
