class CreateConversationUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :conversation_users do |t|
      t.references :user, foreign_key: true
      t.references :conversation, foreign_key: true
      t.boolean :is_creator, default: false
      t.boolean :is_read, default: false
      t.boolean :is_archived, default: false

      t.timestamps
    end
  end
end
