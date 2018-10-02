class CreateReaders < ActiveRecord::Migration[5.2]
  def change
    create_table :readers do |t|
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true

      t.timestamps
    end
  end
end
