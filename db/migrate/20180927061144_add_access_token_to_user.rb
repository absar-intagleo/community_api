class AddAccessTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :access_token, :text
    add_column :users, :expires_in, :string
    add_column :users, :token_created_at, :datetime
  end
end
