class User < ActiveRecord::Base

    has_many :orders
    has_many :restaurants, through: :orders
    
end