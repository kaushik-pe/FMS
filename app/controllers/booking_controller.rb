class BookingController < ApplicationController
  def homepage
  end
  def list
     dateQuery = "schedules."+Date.parse(params[:jrnydate]).strftime("%A").downcase
     unless params[:sortby]
       @flights = Flight.joins(:schedule).where(params.permit(:source,:destination,:airlines)).where(dateQuery=>"t")
       @flights = findPriceClass(@flights)
     end
     if params[:sortby]
       attribute = params[:sortby].to_sym
       if attribute==:price
         @flights = Flight.joins(:schedule).where(params.permit(:source,:destination,:airlines)).where(dateQuery=>"t")
         @flights = findPriceClass(@flights)
         @flights = @flights.sort_by do |flight|
           flight.minPrice
         end
       else
         @flights = Flight.joins(:schedule).where(params.permit(:source,:destination,:airlines),dateQuery=>'t').order(attribute)
         @flights = findPriceClass(@flights)
       end
     end
     if params[:minPrice] and params[:maxPrice]
        @flights = @flights.find_all do |flight|
            flight.minPrice <=  params[:maxPrice].to_i && params[:minPrice].to_i <= flight.maxPrice
        end
     end
     if params[:minTime] and params[:maxTime]
        @flights = @flights.find_all do |flight|
            departureTemp = flight.departure_time.strftime('%H:%M')
            puts "Time #{departureTemp}"
            puts "MinTime #{params[:minTime]}"
            #puts "Time #{arrivalTemp.class}"
            #puts "MinTime #{params[:minTime].class}"
            departureTemp >=  params[:minTime] && departureTemp <= params[:maxTime]
        end
     end
  end
  def book
    puts params[:flight_id]
  end
  def confirm
    puts params
  end

  private
  def findPriceClass(flights)
    for i in 0..flights.length-1
        minPrice = Flight.joins(:schedule,:flighttype).where(:id=>flights[i].id).group("flights.id").minimum("flighttypes.price")
        maxPrice = Flight.joins(:schedule,:flighttype).where(:id=>flights[i].id).group("flights.id").maximum("flighttypes.price")
        flights[i].maxPrice = maxPrice[flights[i].id]
        flights[i].minPrice = minPrice[flights[i].id]
    end
    return flights
  end
end
