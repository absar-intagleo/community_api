class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.string :title
      t.string :absolute_url
      t.boolean :is_archived, default: false

      t.timestamps
    end
  end
end
