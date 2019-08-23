class Restaurant  < ActiveRecord::Base
    
    has_many :orders
    has_many :users, through: :orders

  def self.by_category(response)
    five_restaurants = Restaurant.all.select { |r| r.category.downcase.include?(response) }
    five_restaurants.uniq.shuffle.take(5)
  end
    
end