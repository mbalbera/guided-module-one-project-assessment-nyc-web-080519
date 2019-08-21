require "json"
require "http"
require 'pry'
require 'dotenv/load' 
require_relative '../config/environment.rb'


API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
API_KEY = ENV['APIKEY']
# Original Source: https://github.com/Yelp/yelp-fusion/tree/master/fusion/ruby

class YelpApiAdapter
  # #Returns a parsed json object of the request

  def self.search(location="new york")
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      location: location,
      limit: 50
    }
    response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
    hash = response.parse["businesses"]
  end
end

manhattan_rests = YelpApiAdapter.search("manhattan")
manhattan_rests.each do |mr|
Restaurant.create(
    name: mr["name"],
    category: mr["categories"][0]["title"],
    price: mr["price"],
    rating: mr["rating"],
    url: mr["url"],
    yelp_id: mr["id"]
)
end
# puts "seeded manhattan"

q_rests = YelpApiAdapter.search("queens")
q_rests.each do |qr|
Restaurant.create(
    name: qr["name"],
    category: qr["categories"][0]["title"],
    price: qr["price"],
    rating: qr["rating"],
    url: qr["url"],
    yelp_id: qr["id"]
)
end
# puts "seeded queens"

brook_rests = YelpApiAdapter.search("brooklyn")
brook_rests.each do |br|
Restaurant.create(
    name: br["name"],
    category: br["categories"][0]["title"],
    price: br["price"],
    rating: br["rating"],
    url: br["url"],
    yelp_id: br["id"]
)
end
# puts "seeded bkln"