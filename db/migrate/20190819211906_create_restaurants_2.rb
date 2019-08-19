class CreateRestaurants2 < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :category
      t.string :price
      t.float :rating
      t.string :url
      t.string :yelp_id
      t.timestamps
    end
  end
end
