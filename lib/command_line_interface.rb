require 'pry'
class Cli

  @@current_user = nil

  def self.current_user
    @@current_user
  end
  
  def self.welcome
    puts 'Welcome do you want to sign in or sign up?'
    x = gets.chomp
    if x == "sign in" || "y" == x
      login
    else
      self.new_user
    end 
  end

  def self.login
    puts "enter username"
    username = gets.chomp
    @@current_user = User.find_by(username: username)
      if current_user
          self.menu
      else
          puts "that user does not exist. :( bye!"
      end
  end

  def self.new_user
    puts "what would you like your username to be?"
    n = gets.chomp
    puts "what would you like your password to be?(optional)"
    p = gets.chomp
    puts "where are you ordering from?(optional)"
    l = gets.chomp
    User.create(
      username: n,
      zip_code: l, 
      password: p
      )
    @@current_user = User.find_by(username: n)
    if current_user
      self.menu
    else
      puts "that user does not exist"
    end
  end

  def self.menu
    puts "1. Find a new restaurant"
    puts "2. View Previous Orders"
    puts "3. View my favorite Restaurants"
    puts "4. Restaurant Roulette"
    puts "5. change user settings"
    puts puts 
    puts "What do you want do today?"
    response = gets.chomp
    case response
    when "1" || "new"
      self.find_new_restaurant_options
    when "2" || "previous"
      self.previous_orders
      #reorder from and commonly ordered from
    when "3" || "favorites"
      self.get_user_favorites
    when "4" || "roulette"
      self.roulette
    when "5" || "user settings"
      self.update_user
    else 
      puts "please select 1-5"
      sleep(1)
      self.menu
    end
  end

  def self.find_new_restaurant_options
    puts "What do you want to choose based on?" 
    puts "1. Pick based on price"
    puts "2. Pick based on category"
    puts "3. Pick based on rating"
    response = gets.chomp
    case response
      when "1" || "price"
        self.choose_by_price
      when "2" || "category"
        self.choose_by_category
      when "3" || "rating"
        self.choose_by_rating
      else 
        puts "please select 1-3"
        sleep(1)
        self.find_new_restaurant_options
    end
    
  end


  def self.choose_by_price
    puts "enter $ to $$$$"
    response = gets.chomp
    chosen = Restaurant.all.select do |r|
      r.price == response
    end
    chosen_names = chosen.map { |r| r.name }
    puts chosen_names.shuffle.uniq.take(5)
    puts ""
  end

  def self.choose_by_category
    puts "enter a category"
    response = gets.chomp
    chosen = Restaurant.all.select do |r|
      r.category == response
    end
    chosen_names = chosen.map { |r| r.name }
    if !chosen_names.empty?
      puts
      puts chosen_names.shuffle.uniq.take(5)
    else
      puts "try again"
      puts "Some commmon categories:"
      puts "    -American"
      puts "    -Chinese"
      puts "    -Italian"
      puts "    -Seafood"
      puts "    -Bakeries"
    end
  end


  def self.choose_by_rating
    puts "enter a number 1-5"
    response = gets.chomp
    max = response + 0.5
    min = response - 0.5
    chosen = Restaurant.all.select { |r| r.rating > min && r.rating < max}
    chosen_names = chosen.map { |r| r.name }
    puts chosen_names.shuffle.uniq.take(5)
    puts ""
  end

  def self.roulette
    chosen = Restaurant.all.shuffle.take(1)
    # binding.pry
    puts chosen[0].name
    puts chosen[0].price
    puts chosen[0].rating
    puts "if you like this choice type 'Order' otherwise type 'try again'"
    response = gets.chomp.downcase
    case response
      when 'order'
        new_order = self.place_order(chosen[0]) 
        binding.pry
        puts "order placed at #{new_order.restaurant.name}!"
      when 'try again'
        # binding.pry
        self.roulette
    end
  end

  def self.previous_orders
    Order.all.select{|o| o.user_id == @@current_user.id}
  end

  def self.update_user
    puts "What would you like to update?" 
    puts "1. Username"
    puts "2. Password"
    puts "3. Location"
    response = gets.chomp
    sleep(1)
    puts "What would you like your new #{response} to be?"
    updated = gets.chomp
    case response
      when "1"
        @@current_user.update(name: updated)
      when "2"
          @@current_user.update(password: updated)
      when "3"
          @@current_user.update(zip_code: updated)
    User.update()
    end
  end
  
 def self.get_user_favorites
     favorites = Order.all.select do |o|
       o.favorite && o.user_id == @@current_user.id
     end
     favorites.each_with_index{|f, i|puts "#{i+1}. #{f.restaurant.name}"}
    #  fav_rest_name = favorites.map do |o|
    #    Restaurant.all.each do |r|
    #      if o.restaurant_id == r.id
    #        r.name
    #      end
    #    end
    #  end
    #  puts fav_rest_name
     puts "1. Re-order something from the favorites menu"
     puts "2. Delete something from the favorites menu"
     response = gets.chomp
     case response
     when "1" || "reorder" || "Re-Order"
       self.reorder
     when "2"
       self.delete_from_fav
     else
       puts "INVALID INPUT!!!! Please select 1 or 2"
       sleep(1)
       self.menu
     end
   end

   def self.reorder
     puts "Input restaurant name"
     response = gets.chomp
     x = Restaurant.all.find_by(name:response)
     self.place_order(x)
   end # FIX THIS FIRST TMW WE NEED TO NUMBER THE LIST OF FAVS AND GET THAT INPUT AND THEN RUN PLACE ORDER

   def self.delete_from_fav
     Order.all.each do |o|
       if o.favorite && o.user_id == @@current_user.id
         o.favorite = false
       end
     end
   end

  def self.place_order(restaurant) #need to grab restaurant instance from menu selection
    new_order = Order.new(
    user_id: current_user.id,
    restaurant_id: restaurant)
    # self.after_order_options
  end

end #CLI class end