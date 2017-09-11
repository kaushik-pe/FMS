class FlightsController < ApplicationController
  def new
  end
  def create
    @flight = Flight.new(params.require(:flight).permit(:source,:destination,:arrival_time,:departure_time,:airline));
    @flight.save
    redirect_to @flight
  end
end
