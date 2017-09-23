class Flight < ApplicationRecord
  has_one :schedule
  has_many :flighttype
  has_many :booking
  attr_accessor :maxPrice,:minPrice
end
