class Flight < ApplicationRecord
  has_one :schedule
  has_many :flighttype
  attr_accessor :maxPrice,:minPrice
end
