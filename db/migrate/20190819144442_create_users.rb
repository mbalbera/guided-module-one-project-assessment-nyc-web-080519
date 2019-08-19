class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.integer :zip_code
      t.string :password
      t.timestamps
    end
  end
end
