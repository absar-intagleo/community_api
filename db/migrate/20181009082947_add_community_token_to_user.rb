class AddCommunityTokenToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :community_token, :string
  	add_column :users, :community_id, :integer
  end
end
