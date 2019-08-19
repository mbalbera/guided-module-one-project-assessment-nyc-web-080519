require_relative '../config/environment'
require_relative '../lib/api_communicator'
require_relative '../lib/command_line_interface'
puts "hello world"
YelpApiAdapter.search("manhattan")