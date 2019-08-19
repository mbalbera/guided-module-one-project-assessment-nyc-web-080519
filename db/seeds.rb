require "json"
require "http"
# require 'rest-client'
require 'pry'

API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
API_KEY = "WY8ibitP0T4k63wHr40eiFW-wnHEOnny2Dev3wt-d3Ws92yl95IQI1KQvRLwoRZZvyzcwEi68utjuCGNtT82EhXwMe6EP44WmM0WeazoHfAB_NM9KJ7amHQH6eHCXHYx"
DEFAULT_BUSINESS_ID = "yelp-san-francisco"
DEFAULT_TERM = "dinner"
DEFAULT_LOCATION = "New York, NY"
# SEARCH_LIMIT = 5

# Original Source: https://github.com/Yelp/yelp-fusion/tree/master/fusion/ruby

class YelpApiAdapter
  # #Returns a parsed json object of the request

  def self.search(location="new york")
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
    #   term: term,
      location: location,
      limit: 50
      
    }
    response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
    thing = response.parse["businesses"]
    binding.pry
  end
end
#   def self.search_all
#     url = "#{API_HOST}#{SEARCH_PATH}"
#     response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
#     thing = response.parse["businesses"]
#     # binding.pry
#   end

#   def self.business_reviews(business_id)
#     url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}/reviews"
#     response = HTTP.auth("Bearer #{API_KEY}").get(url)
#     response.parse["reviews"]
#   end
  
#   def business(business_id)
#     url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"
#     response = HTTP.auth("Bearer #{API_KEY}").get(url)
#     response.parse
#   end
  
# end



manhattan_rests = YelpApiAdapter.search("manhattan")
manhattan_rests.each do |mr|
Restaurant.create(
    name: mr["name"]
    category: mr["category"]
    price: mr["price"]
    rating: mr["rating"]
    url: mr["url"]
    yelp_id: mr["id"]
)
end
