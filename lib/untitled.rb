# def self.roulette
  #     puts `clear`
  #     chosen = Restaurant.all.shuffle.first
  #     puts
  #     puts "How about this one?".colorize(:magenta)
  #     sleep(0.5)
  #     puts
  #     puts chosen.name
  #     # puts chosen.price
  #     # puts chosen.rating
  # #add table with restaurant info!!!
  #     sleep(0.25)
  #     puts
  #     puts
  #     puts "If you like this choice type 'order' otherwise type 'try again'.".colorize(:green)
  #     puts
  #     response = gets.chomp.downcase
  
  #     case response
  #     when 'order'
  #       new_order = self.place_order(chosen) 
  #       sleep(0.5)
  #     when 'try again'
  #       self.roulette
  #     else
  #       puts "INVALID INPUT. Please only type 'order' or 'try again'.".colorize(:red)
  #       self.roulette
  #     end
  #   end


  # five_restaurants.each_with_index { |object, idx| puts "#{idx+1}. #{object.name}"}
    #binding.pry
    # table = Text::Table.new
    # table.head = ["No.", "Name", "Price", "Rating"]
    # five_restaurants.each_with_index do |object, idx| 
    #   table.rows = [["#{idx+1}", object.name, object.price, object.rating]]
    #   #puts "#{idx+1}. #{object.name}"
    # end
    
    #table.rows << ['a2', 'b2']

    # puts five_restaurants.to_table


  # table = Text::Table.new
  #   table.head = ["No.", "Name", "Price", "Rating"]
  #   table.rows = [["1", chosen.name, chosen.price, chosen.rating]]
  #   #table.rows << ['a2', 'b2']

  #   puts table.to_s

  # table = [["No.", "Name", "Price", "Rating"]]
  # five_restaurants.each_with_index do |obj, idx|
  #   table << ["#{idx +1}", obj.name, obj.price, obj.rating]
  # end

  # puts table.to_table(:first_row_is_head => true)
