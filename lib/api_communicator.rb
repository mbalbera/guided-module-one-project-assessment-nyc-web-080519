require "json"
require "http"
# require 'rest-client'
require 'pry'
require_relative 'hidden'
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
API_KEY = APIKEY
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
    # binding.pry
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





# # def get_restaurant_from_api(restaurant)
# #   #make the web request
# #   response_string = RestClient.get('url'})
# #   response_hash = JSON.parse(response_string)
# #   binding.pry
# #   # iterate over the response hash to find the collection of `films` for the given
# #   #   `character`
# #   # collect those film API urls, make a web request to each URL to get the info
# #   #  for that film
# #   # return value of this method should be collection of info about each film.
# #   #  i.e. an array of hashes in which each hash reps a given film
# #   # this collection will be the argument given to `print_movies`
# #   #  and that method will do some nice presentation stuff like puts out a list
# #   #  of movies by title. Have a play around with the puts with other info about a given film.
# # end

# # def print_restaurants(restaurants)
# #   # some iteration magic and puts out the movies in a nice list
# # end

# # def show_restaurant_by_location(restaurant)
# #   restaurants = get_restaurant_by_location_from_api(character)
# #   print_movies(restaurants)
# # end


