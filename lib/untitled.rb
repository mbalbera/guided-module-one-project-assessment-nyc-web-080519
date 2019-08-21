


def self.place_order(restaurant) #need to grab restaurant instance from menu selection
  new_order = Order.create(
    user_id: current_user.id,
    restaurant_id: restaurant.id
  )
  puts "Order placed at #{restaurant.name}"
  self.add_rating(new_order)
end

def self.previous_orders
  orders = Order.all.select{ |o| o.user_id == current_user.id }
  uniq_orders = orders.uniq { |order| order.restaurant.name }
  uniq_orders.each_with_index { |order, idx| puts "#{idx+1}. #{order.restaurant.name}"}
  puts "Please enter a number for desired action"
  puts "1. Reorder from one of these restaurants"
  puts "2. Return to main menu"
  response = gets.chomp
  case response
  when "1"
    puts "Please enter the number of the restaurant you want to reorder from."
    response_two = gets.chomp.to_i
    self.reorder(uniq_orders[response_two - 1])
  when "2"
    self.menu
  else 
    puts "INVALID INPUT. Please enter either 1 or 2."
    self.previous_orders
  end
end