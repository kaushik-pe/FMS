class BookingController < ApplicationController
  def homepage
  end
  def list
     dateQuery = "schedules."+Date.parse(params[:jrnydate]).strftime("%A").downcase
     unless params[:sortby]
       @flights = Flight.joins(:schedule).where(:source=>params[:source],:destination=>params[:destination],dateQuery=>'t')
       @flights = findPriceClass(@flights)
     end
     if params[:sortby]
       attribute = params[:sortby].to_sym
       if attribute==:price
         @flights = Flight.joins(:schedule).where(:source=>params[:source],:destination=>params[:destination],dateQuery=>'t')
         @flights = findPriceClass(@flights)
         puts "Sorting by price"
         @flights = @flights.sort_by do |flight|
           flight.minPrice
         end
       else
         @flights = Flight.joins(:schedule).where(:source=>params[:source],:destination=>params[:destination],dateQuery=>'t').order(attribute)
         @flights = findPriceClass(@flights)
       end
     end

  end

  private
  def findPriceClass(flights)
    puts "Length"
    puts flights.length
    for i in 0..flights.length-1
        minPrice = Flight.joins(:schedule,:flighttype).where(:id=>flights[i].id).group("flights.id").minimum("flighttypes.price")
        maxPrice = Flight.joins(:schedule,:flighttype).where(:id=>flights[i].id).group("flights.id").maximum("flighttypes.price")
        flights[i].maxPrice = maxPrice[flights[i].id]
        flights[i].minPrice = minPrice[flights[i].id]
    end
    return flights
  end
end
