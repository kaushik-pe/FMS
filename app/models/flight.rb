class Flight < ApplicationRecord
  @availableSeatMap = {}
  has_one :schedule
  has_many :flighttype
  has_many :booking
  attr_accessor :maxPrice,:minPrice
  attr_accessor :availableSeatMap
end
