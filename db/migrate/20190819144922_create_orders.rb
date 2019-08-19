class CreateOrders < ActiveRecord::Migration[5.2]
  def change 
    create_table :orders do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :rating
      t.timestamps
    end
  end
end
