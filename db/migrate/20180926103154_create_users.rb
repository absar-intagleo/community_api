class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :uuid
      t.string :email
      t.string :absolute_url
      t.string :avatar
      t.string :avatar_thumbnail
      t.string :cover
      t.string :cover_cropped

      t.timestamps
    end
  end
end
