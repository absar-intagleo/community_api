class Reader < ApplicationRecord
  belongs_to :user
  belongs_to :message

  scope :read_by, -> { where(is_read: true) }
end
