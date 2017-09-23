class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :passenger
  belongs_to :flight
end
