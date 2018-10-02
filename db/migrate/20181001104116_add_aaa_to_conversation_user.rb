class AddAaaToConversationUser < ActiveRecord::Migration[5.2]
  def change
    add_column :conversation_users, :archive_number, :string
    add_column :conversation_users, :archived_at, :datetime
  end
end
