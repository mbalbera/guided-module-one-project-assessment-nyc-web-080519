require 'pry'
require_relative "./egg.rb"

class Cli

  extend Ew

  @@current_user = nil

  def self.current_user
    @@current_user
  end

  def self.ascii_welcome
    puts "                       Welcome to...".colorize(:magenta)
    sleep(0.5)
    puts
    puts <<-ASCII
     /$$      /$$  /$$$$$$$$  /$$        /$$$$$$$   /$$
    | $$  /$ | $$ | $$_____/ | $$       | $$__  $$ | $$
    | $$ /$$$| $$ | $$       | $$       | $$    $$ | $$
    | $$/$$ $$ $$ | $$$$$    | $$       | $$$$$$$/ | $$
    | $$$$_  $$$$ | $$__/    | $$       | $$____/  |__/
    | $$$/    $$$ | $$       | $$       | $$          
    | $$/      $$ | $$$$$$$$ | $$$$$$$$ | $$        /$$
    |__/      __/ |________/ |________/ |__/       |__/
    ASCII
    puts 
    sleep(0.5)
    puts "                 It's definitely not Yelp! ".colorize(:magenta)
  end
  
  def self.welcome
    puts `clear`
    self.ascii_welcome
    sleep(0.75)
    puts "\n\nPlease enter a number to get started:".colorize(:green)
    self.login_or_create_account 
  end

  def self.login_or_create_account
    puts "\n1. Log in".colorize(:cyan)
    puts "2. Create a new account\n".colorize(:cyan)
    response = gets.chomp
    if response == "1"
      puts `clear`
      self.login
    elsif response == "2"
      puts `clear`
      self.new_user
    elsif response == "all"
      self.all_users
    else
      self.invalid_response_one_two
      self.login_or_create_account
    end
  end

  def self.login
    puts "\nPlease enter your username:\n".colorize(:green) 
    username = gets.chomp.downcase
    @@current_user = User.find_by(username: username)
    if current_user
      puts `clear`
      puts "Hello, #{current_user.username}!\n".colorize(:cyan)
      sleep(1.15)
      self.menu
    elsif username == "evans"
      Ew.spicy
      sleep(0.25)
      self.exit
    else
      puts "\nThis user does not exist.\n".colorize(:red)
      puts "Please enter 1 or 2 to log in again or to create a new account.\n".colorize(:green)
      self.login_or_create_account
    end
  end

  def self.new_user
    puts "Please enter a new username:\n".colorize(:green)

    username = gets.chomp.downcase
    if User.find_by(username: username)
      puts "Sorry, #{username} is already taken. Please enter a different username.".colorize(:red)
      sleep(0.5)
      self.new_user
    else
      User.create(username: username) 

      @@current_user = User.find_by(username: username)
      if current_user
        puts `clear`
        puts "\nNew user account has been created.".colorize(:magenta)
        sleep(1)
        puts `clear`
        puts "Hello, #{current_user.username}!\n".colorize(:cyan)
        self.menu 
      else
        puts "Unable to create a new user account. Please start again.\n".colorize(:red)
        self.login_or_create_account
      end
    end
  end

  def self.menu
    puts "Main Menu".colorize(:magenta)
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~".colorize(:magenta)
    sleep(0.1)
    # system "say 'bloop'"
    puts "1. Find a new restaurant to order from"
    sleep(0.1)
    # system "say 'bloop'"
    puts "2. View your previous orders"
    sleep(0.1)
    # system "say 'bloop'"
    puts "3. View your favorite restaurants"
    sleep(0.1)
    # system "say 'bloop'"
    puts "4. Pick a totally random restaurant"
    sleep(0.1)
    # system "say 'bloop'"
    puts "5. Change your user settings"
    sleep(0.1)
    # system "say 'bloop'"
    puts "6. Exit program"
    puts 
    sleep(0.2)
    puts "Please enter a number between 1 and 6 for your desired action.".colorize(:green)
    puts
    response = gets.chomp
    case response
    when "1" || "new"
      puts `clear`
      sleep(0.25)
      self.find_new_restaurant_options
    when "2" || "previous"
      puts `clear`
      sleep(0.25)
      self.previous_orders
    when "3" || "favorites"
      puts `clear`
      sleep(0.25)
      self.get_user_favorites
      puts `clear`
      sleep(0.25)
    when "4" || "roulette"
      puts `clear`
      sleep(0.25)
      self.roulette
    when "5" || "user settings"
      puts `clear`
      sleep(0.25)
      self.update_user
    when "6"
      puts `clear`
      sleep(0.25)
      self.exit
    else 
      system "\nsay 'oops'"
      puts "Invalid response. Please enter a number 1-6.\n".colorize(:red)
      sleep(1)
      self.menu
    end
  end

  def self.find_new_restaurant_options
    puts "Please enter 1 or 2 for how you want to choose your restaurant.".colorize(:green)
    puts
    puts "1. Choose based on price"
    puts "2. Choose based on type of food"
    puts
    response = gets.chomp
    case response
    when "1"
      puts `clear`
      self.choose_by_price
    when "2"
      puts `clear`
      self.choose_by_category
    else 
      puts `clear`
      self.invalid_response_one_two
      # puts "Invalid response. Please enter 1 or 2.".colorize(:red)
      sleep(1)
      self.find_new_restaurant_options
    end
  end


  def self.choose_by_price
    # puts `clear`

    puts "Please enter a number between 1 and 4 for desired price range.".colorize(:green)
    puts
    puts "1. $"
    puts "2. $$"
    puts "3. $$$"
    puts "4. $$$$"
    puts
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
      system "\nsay 'oops'"
      puts "Invalid response. Please enter a number 1-4.\n".colorize(:red)
      sleep(0.5)
      self.choose_by_price
    end
    system("clear")
    five_restaurants = Restaurant.all.select { |r| r.price == dollars}.uniq.shuffle.take(5)
    self.pick_from_five(five_restaurants)
    
  end

  def self.pick_from_five(five_restaurants)
    puts "Here are some restaurants that match that search:\n".colorize(:magenta)
    
    table = [["No.", "Name", "Price", "Rating"]]
    five_restaurants.each_with_index do |obj, idx|
      table << ["#{idx +1}", obj.name, obj.price, obj.rating]
    end

    puts table.to_table(:first_row_is_head => true)

    puts "\nPlease enter the number of the restaurant you'd like to order from, or type 'menu' to return to the main menu:\n".colorize(:green)

    response = gets.chomp 
    if response == 'menu'
      puts "\nReturning to main menu...\n"
      sleep(1.5)
      puts `clear`
      self.menu
    end
    
    response = response.to_i - 1

    if response >= 0 && response < five_restaurants.length
      restaurant = five_restaurants[response]
      self.place_order(restaurant)
    else
      system "\nsay 'oops'"
      puts "Invalid response. Please enter a number between 1 and #{five_restaurants.length} or type 'menu'".colorize(:red)
      sleep(1)
      self.pick_from_five(five_restaurants)
    end
  end


  def self.choose_by_category
    puts "What type of food are you hungry for? Type something like 'pizza'\n".colorize(:green)
    response = gets.chomp.downcase
    # five_restaurants = Restaurant.all.select { |r| r.category.downcase.include?(response) }
    # five_restaurants = five_restaurants.uniq.shuffle.take(5)
    five_restaurants = Restaurant.by_category(response)

    if !five_restaurants.empty?
      self.pick_from_five(five_restaurants)
    else
      puts "\nSorry, this category does not exist. Let's try again.\n".colorize(:red)
      puts "Here are some popular categories:".colorize(:red)
      puts "    American"
      puts "    Thai"
      puts "    Italian"
      puts "    Seafood"
      puts "    Bakeries\n"
      self.choose_by_category
    end
  end

  #updated with table
  def self.roulette
    puts `clear`
    chosen = Restaurant.all.shuffle.first
    puts "\nHow about this one?\n".colorize(:magenta)
    sleep(0.5)

    table = Text::Table.new
    table.head = ["No.", "Name", "Price", "Rating"]
    table.rows = [["1", chosen.name, chosen.price, chosen.rating]]

    puts table.to_s

    sleep(0.25)
    puts "\n\nIf you like this choice type 'order' otherwise type 'try again'.\n".colorize(:green)

    response = gets.chomp.downcase

    case response
    when 'order'
      new_order = self.place_order(chosen) 
      sleep(0.5)
    when 'try again'
      self.roulette
    else
      system "\nsay 'oops'"
      puts "Invalid response. Please only type 'order' or 'try again'.".colorize(:red)
      sleep(1)
      self.roulette
    end
  end
  
  def self.previous_orders
    orders = Order.all.select{ |o| o.user_id == current_user.id }
    uniq_orders = orders.uniq { |order| order.restaurant.name }
    sleep(1)
    if uniq_orders.length == 0
      puts "You haven't placed any orders yet. Let's find a restaurant!".colorize(:magenta)
      puts
      sleep(1)
      self.find_new_restaurant_options
    else
      puts "Here are all the restaurants you've previously ordered from:".colorize(:magenta)
      puts
      uniq_orders.each_with_index { |order, idx| puts "#{idx+1}. #{order.restaurant.name}"}
      puts
      puts "What would you like to do next? (Enter 1 or 2)".colorize(:green)
      puts "1. Reorder from one of these restaurants"
      puts "2. Return to the main menu"
      response = gets.chomp
      case response
      when "1"
        puts
        puts "Please enter the number of the restaurant you want to reorder from.".colorize(:green)
        puts
        response_two = gets.chomp.to_i
        self.reorder(uniq_orders[response_two - 1])
      when "2"
        system("clear")
        self.menu
      else 
        puts
        # puts "Invalid response. Please enter either 1 or 2.".colorize(:red)
        self.invalid_response_one_two
        self.previous_orders
      end
    end #end of first if statement
  end

  def self.update_user
    puts "What would you like to do?".colorize(:green) 
    puts
    puts "1. Change your username"
    puts "2. Delete your account"
    puts "3. Return to main menu"
    puts
    response = gets.chomp
    sleep(1)
    case response
    when "1"
      puts
      puts "Please enter your new username:".colorize(:green)
      puts
      updated = gets.chomp.downcase
      if User.find_by(username: updated)
        puts "Sorry, #{updated} is already taken. Please try again."
        sleep(1.5)
        self.update_user
      else
        current_user.update(username: updated)
        puts "Your username has been changed to #{current_user.username}".colorize(:magenta)
        sleep(0.25)
        puts "Returning to main menu..."
        sleep(1.5)
        system("clear")
        self.menu
      end
    when "2"
      puts
      puts "Are you sure you want to delete your account? Enter 'yes' to delete or 'no' to return to the main menu.".colorize(:red)
      double_check = gets.chomp.downcase

      if double_check == 'yes'
        User.delete(current_user)
        puts "Your username has been deleted.".colorize(:magenta) 
        sleep(1)
        self.exit
      else
        puts 
        puts "Returning to main menu..."
        sleep(1)
        puts `clear`
        self.menu
      end
    else
      puts "Returning to main menu..."
      sleep(0.75)
      puts `clear`
      self.menu
    end
  end
  
  def self.get_user_favorites
    # puts `clear`
    orders = Order.all.select{ |o| o.user_id == current_user.id && o.favorite}
    uniq_orders = orders.uniq { |order| order.restaurant.name }
    sleep(1)
    if uniq_orders.length == 0
      puts "You haven't favorited any orders yet. :( ".colorize(:magenta)
      puts
      puts "Returning to the main menu..."
      sleep(2)
      puts `clear`
      self.menu
    else
      puts "Here are all the restaurants you've added to your favorites:".colorize(:magenta)
      puts
      uniq_orders.each_with_index { |order, idx| puts "#{idx+1}. #{order.restaurant.name}"}
      puts 
      puts "What would you like to do next? (Enter 1, 2, or 3)".colorize(:green)
      puts "1. Reorder from one of these restaurants"
      puts "2. Remove a restaurant from your list of favorites"
      puts "3. Return to main menu"
      puts
      response = gets.chomp
      case response
      when "1"
        puts
        puts "Please enter the number of the restaurant you want to reorder from.".colorize(:green)
        puts
        response_two = gets.chomp.to_i
        self.reorder(uniq_orders[response_two - 1])
      when "2"
        puts
        puts "Please enter the number of the restaurant you want to remove.".colorize(:green)
        puts
        response_two = gets.chomp.to_i
        uniq_orders[response_two - 1].update(favorite: false)
        puts "This order has been removed from your favorites"
        puts
        sleep(1)
        system("clear")
        self.get_user_favorites
      when "3"
        system("clear")
        self.menu
      else 
        puts
        puts "Invalid response. Please enter either 1, 2 or 3.".colorize(:red)
        puts
        sleep(0.25)
        self.get_user_favorites
      end
    end
  end

  def self.reorder(order)
    puts `clear`
    new_order = Order.create(
      user_id: current_user.id,
      restaurant_id: order.restaurant.id
    )
    sleep(0.5)
    puts
    puts "Order placed at #{order.restaurant.name}!".colorize(:magenta)
    puts 
    puts "Returning to main menu..."
    sleep(1.75)
    puts `clear`
    self.menu
  end

  def self.place_order(restaurant)
    new_order = Order.create(
      user_id: current_user.id,
      restaurant_id: restaurant.id
    )
    puts `clear`
    sleep(0.5)
    puts
    puts "Order placed at #{restaurant.name}!".colorize(:magenta)
    puts
    puts
    self.add_rating(new_order)
  end

  def self.add_rating(order)
    puts "Please enter a rating between 1 and 5 for this order.".colorize(:green)
    puts
    response = gets.chomp
    if response.to_i > 0 && response.to_i <= 5 
      order.update(rating: response.to_i)
    else
      system "say 'oops'"
      puts "Invalid response. Please enter a rating between 1 and 5.".colorize(:red)
      puts
      self.add_rating(order)
    end
    puts
    self.add_to_favorites(order)
  end

  def self.add_to_favorites(order)
    #binding.pry
    puts "Would you like to add this to your favorites?".colorize(:green)
    puts "1. Yes!!!!!!!"
    puts "2. Nah"
    response = gets.chomp
    case response
    when "1"
      system("clear")
      order.update(favorite: true)
      puts
      puts "#{order.restaurant.name} has been added to your favorite restaurants.".colorize(:magenta)
      puts
      puts "Returning to the main menu..."
      sleep(2.0)    
    when "2"
      puts "\nSorry that #{order.restaurant.name} wasn't one of your favorites".colorize(:magenta)
      puts
      puts "Returning to the main menu..."
      sleep(2.0)
    else
      self.invalid_response_one_two
      # puts "Invalid response. Please enter 1 or 2."
      self.add_to_favorites(order)
    end
    puts `clear`
    self.menu
  end

  def self.invalid_response_one_two
    puts
    system "say 'oops'"
    puts "Invalid response. Please enter either 1 or 2".colorize(:red)
    puts
  end

  def self.exit
    puts `clear`
    puts "Welp, bye!!!!!"
    sleep(1)
    puts `clear`

  end

  #------hidden------#
  def self.all_users
    puts "This is a secret method that prints all user names"
    User.all.each { |user| puts "#{user.username}"}
  end

end #CLI class end