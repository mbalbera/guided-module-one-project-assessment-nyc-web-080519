def welcome
  puts 'Login!'
end

def login(username)
    if Users.username.include?(username)
        "next step"
    else
        puts "that user does not exist"
    end

end

def get_character_from_user
  puts "please enter a character name"
  # use gets to capture the user's input. This method should return that input, downcased.
  input = gets.chomp.downcase 
end
