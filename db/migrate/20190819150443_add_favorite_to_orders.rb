class AddFavoriteToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :favorite, :boolean, default: false
  end
end
