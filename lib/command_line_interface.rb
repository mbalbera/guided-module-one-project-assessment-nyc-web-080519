require 'pry'

class Cli

  @@current_user = nil

  def self.current_user
    @@current_user
  end
  
  def self.welcome
    puts 'Welcome. Please enter a number.'
    self.login_or_create_account 
  end

  def self.login_or_create_account
    puts "1. Login"
    puts "2. Create a new account"
    response = gets.chomp
    if response == "1"
      login
    elsif response == "2"
      self.new_user
    else
      puts "INVALID INPUT. Please enter a number."
      self.login_or_create_account
    end
  end

  def self.login
    puts "Please enter your username."
    username = gets.chomp.downcase
    @@current_user = User.find_by(username: username)
    if current_user
      system("clear")
      puts "Welcome, #{current_user.username}!".colorize(:green)
      puts
      sleep(1)
      self.menu
    else
      puts "This user do not exist.".colorize(:red)
      puts "Please enter the number to login again or to create a new account.".colorize(:green)
      self.login_or_create_account
    end
  end

  def self.new_user
    puts "Please enter new username:"
    n = gets.chomp.downcase
    User.create(
      username: n
    )
    @@current_user = User.find_by(username: n)
    if current_user
      puts "New user account has been created."
      puts puts
      self.menu 
    else
      puts "Unable to create a new user account. Please start again."
      self.login_or_create_account
    end
  end

  def self.menu
    puts "1. Find a new restaurant"
    puts "2. View previous orders"
    puts "3. View my favorite restaurants"
    puts "4. Restaurant Roulette"
    puts "5. Change user settings"
    puts "6. Exit program"
    puts 
    puts "Please enter a number between 1 and 5 for your desired action."
    response = gets.chomp
    case response
    when "1"
      self.find_new_restaurant_options
    when "2"
      self.previous_orders
    when "3"
      self.get_user_favorites
    when "4"
      self.roulette
    when "5"
      self.update_user
    when "6"
      self.exit
    else 
      puts "INVALID INPUT. Please enter a number 1-5."
      sleep(1)
      self.menu
    end
  end

  def self.find_new_restaurant_options
    puts "Please enter 1 or 2 for how you want to choose your restaurant." 
    puts "1. Pick based on price"
    puts "2. Pick based on category"
    response = gets.chomp
    case response
    when "1"
      self.choose_by_price
    when "2"
      self.choose_by_category
    else 
      puts "INVALID INPUT. Please enter 1 or 2."
      sleep(1)
      self.find_new_restaurant_options
    end
  end

  def self.choose_by_price
    puts "Please enter a number between 1 and 4 for desired price range."
    puts "1. $"
    puts "2. $$"
    puts "3. $$$"
    puts "4. $$$$"
    response = gets.chomp

    case response
    when "1"
      dollars = "$"
    when "2"
      dollars = "$$"
    when "3"
      dollars = "$$$"
    when "4"
      dollars = "$$$$"
    else
      puts "INVALID INPUT. Please enter a number 1-3."
      sleep(1)
      self.choose_by_price
    end

    five_restaurants = Restaurant.all.select { |r| r.price == dollars}.uniq.shuffle.take(5)
    self.pick_from_five(five_restaurants)
  end

  def self.pick_from_five(five_restaurants)
    five_restaurants.each_with_index { |object, idx| puts "#{idx+1}. #{object.name}"}
    puts "Please enter a number for desired restaurant to order from."
    response = gets.chomp.to_i - 1
    if response >= 0 && response < five_restaurants.length
      restaurant = five_restaurants[response]
      self.place_order(restaurant)
    else
      puts "INVALID INPUT. Please enter a number between 1 and #{five_restaurants.length}"
      self.pick_from_five(five_restaurants)
    end
  end


  def self.choose_by_category
    puts "Please enter a desire category."
    response = gets.chomp
    five_restaurants = Restaurant.all.select { |r| r.category.downcase.include?(response) }
    five_restaurants = five_restaurants.uniq.shuffle.take(5)

    if !five_restaurants.empty?
      self.pick_from_five(five_restaurants)
    else
      puts "This category does not exist. Please enter a new category."
      puts "Here are some popular categories:"
      puts "    American"
      puts "    Thai"
      puts "    Italian"
      puts "    Seafood"
      puts "    Bakeries"
      self.choose_by_category
    end
  end

  def self.roulette
    chosen = Restaurant.all.shuffle.first
    puts chosen.name
    puts chosen.price
    puts chosen.rating
    puts "If you like this choice type 'order' otherwise type 'try again'."
    response = gets.chomp.downcase

    case response
    when 'order'
      new_order = self.place_order(chosen) 
      puts "Order placed at #{new_order.restaurant.name}!"
    when 'try again'
      self.roulette
    else
      puts "INVALID INPUT. Please only type 'order' or 'try again'."
      self.roulette
    end
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

  def self.update_user
    puts "What would you like to do?" 
    puts "1. Change username"
    puts "2. Delete your account"
    response = gets.chomp
    sleep(1)
    case response
    when "1"
      puts "Please enter your new username:"
      updated = gets.chomp.downcase
      current_user.update(username: updated)
      puts "Your username has been changed to #{current_user.username}"
      self.menu
    when "2"
      User.delete(current_user)
      puts "Your username has been deleted."
      self.exit
    end
  end
  
  def self.get_user_favorites
    orders = Order.all.select{ |o| o.user_id == current_user.id && o.favorite}
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

  def self.reorder(order)
    new_order = Order.create(
    user_id: current_user.id,
    restaurant_id: order.restaurant.id
    )
    puts "Order placed at #{order.restaurant.name}"
    self.menu
  end

  def self.place_order(restaurant)
    new_order = Order.create(
      user_id: current_user.id,
      restaurant_id: restaurant.id
    )
    puts "Order placed at #{restaurant.name}"
    self.add_rating(new_order)
  end

  def self.add_rating(order)
    puts "Please enter a rating between 1 and 5 for this order."
    response = gets.chomp
    if response.to_i >= 0 && response.to_i <= 5 
      order.update(rating: response.to_i)
    end
    self.add_to_favorites(order)
  end

  def self.add_to_favorites(order)
    puts "Would you like to add this to your favorites?"
    puts "1. yes"
    puts "2. no"
    response = gets.chomp
    case response
    when "yes" || "1"
      order.update(favorite: true)
    when "no" || "2"
      puts "Thank you!"
    end
    self.menu
  end

  def self.exit
    puts "Good-bye"
    sleep(1)
  end

end #CLI class end