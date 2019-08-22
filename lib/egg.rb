module Ew


  def self.spicy
    pepper = <<-PEPPER
    /|
    .-((--. 
   ( '`^'; )
   `;#    |
    /\#    |
     /\#   \
      '-.  )
         /\(
          `

    PEPPER

    spicy = <<-SPICY


     ad88888ba   88888888ba   88    ,ad8888ba,  8b        d8  
    d8"     "8b  88      "8b  88   d8"'    `"8b  Y8,    ,8P   
    Y8,          88      ,8P  88  d8'             Y8,  ,8P    
    `Y8aaaaa,    88aaaaaa8P'  88  88               "8aa8"     
      `"""""8b,  88""""""'    88  88                `88'      
            `8b  88           88  Y8,                88       
    Y8a     a8P  88           88   Y8a.    .a8P      88       
     "Y88888P"   88           88    `"Y8888Y"'       88       
                                                              
        
    SPICY
    10.times do
      puts spicy.colorize(:color => :green)
      # system "say 'spicy'"
      sleep(0.2)
      puts spicy.colorize(:color => :red)
      # system "say 'spicy'"
      sleep(0.2)
    end
    
  end

end

