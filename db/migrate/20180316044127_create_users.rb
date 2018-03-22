class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :foursquare_id
      t.string :photo

      t.timestamps
    end
  end
end
