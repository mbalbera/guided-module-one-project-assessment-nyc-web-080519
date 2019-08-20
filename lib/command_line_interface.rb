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
    when "1"
      self.find_new_restaurant_options
    when "2"
      self.previous_orders
      #reorder from and commonly ordered from
    when "3"
      self.get_user_favorites
    when "4"
      self.roulette
    when "5"
      self.update_user
    else 
      puts "please select 1-5"
      sleep(1)
      self.menu
    end
      
    
    #call whatever function asked for with gets.chomp response 
  end

  def self.find_new_restaurant_options
    puts "1. Pick based on price"
    puts "2. Pick based on category"
    puts "3. Pick based on rating"
    puts "4. Pick based on location"
    puts "What do you want to choose based on?"
    response = gets.chomp
    self.choose_by_price
  end

  def self.choose_by_price
    puts "enter $ to $$$$"
    response = gets.chomp
    chosen = Restaurant.all.select do |r|
      # binding.pry
      r.price == response
    end
    chosen_names = chosen.map { |r| r.name }
    puts chosen_names.shuffle.uniq.take(5)
    puts ""
  end

    def self.roulette
    end

    def self.previous_orders
    end

    def self.update_user
    end
    
    def self.get_user_favorites
    end
end #ends cli class