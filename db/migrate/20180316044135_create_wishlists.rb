class CreateWishlists < ActiveRecord::Migration[5.0]
  def change
    create_table :wishlists do |t|
      t.string :venue_id
      t.string :venue_photo
      t.string :venue_name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
