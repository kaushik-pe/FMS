class BookingController < ApplicationController
  skip_before_action :verify_authenticity_token
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
            departureTemp >=  params[:minTime] && departureTemp <= params[:maxTime]
        end
     end
  end

  def book
    puts params[:flight_id]
  end

  def confirm
    user = User.first
    bookingno = user.name+rand(10 ** 10).to_s
    flight_id = params["flight_id"]
    doj = params["jrnydate"]
    params["passenger"].each do |outkey,outvalue|
      temp = Hash.new
      params["passenger"][outkey].permit(:name,:age,:aadharno).each do|key,value|
        key = key.to_sym
        temp[key] = value
      end
       passenger = Passenger.create(temp)
       booked = findBookedSeats(flight_id,doj,params["passenger"][outkey]["class"])
       totalno = findTotalSeats(flight_id,params["passenger"][outkey]["class"])
       total = generateTotalSeats(totalno)
       available = total-booked
       seatno = available.first
       bookdate = Time.now.strftime("%d/%m/%Y")
       addBooking(user.id,bookingno,flight_id,passenger.id,seatno,bookdate,"Booked",doj,params["passenger"][outkey]["class"])
    end

  end
  private
  def addBooking(userid,bookingno,flight_id,passengerid,seatno,bookdate,status,doj,classname)
    temp = Booking.create(:user_id=>userid,:bookingno=>bookingno,:flight_id=>flight_id,:passenger_id=>passengerid,:seatno=>seatno,:bookingdate=>bookdate,:status=>status,:doj=>doj,:classname=>classname)
  end

  def findPriceClass(flights)
    for i in 0..flights.length-1
        minPrice = Flight.joins(:schedule,:flighttype).where(:id=>flights[i].id).group("flights.id").minimum("flighttypes.price")
        maxPrice = Flight.joins(:schedule,:flighttype).where(:id=>flights[i].id).group("flights.id").maximum("flighttypes.price")
        flights[i].maxPrice = maxPrice[flights[i].id]
        flights[i].minPrice = minPrice[flights[i].id]
    end
    return flights
  end

  def findBookedSeats(flight_id,doj,classname)
    temp = Booking.where(:flight_id=>flight_id,:doj=>doj,:classname=>classname).pluck(:seatno)
    for i in 0..temp.length-1
      temp[i] = temp[i].to_i
    end
    return temp
  end

  def findTotalSeats(flight_id,classname)
    temp = Flight.joins(:flighttype).select("flighttypes.noofseats").where(:id=>flight_id,"flighttypes.classname"=>classname)
    return temp[0].noofseats
  end

  def generateTotalSeats(totalno)
    total = []
      for i in 1..totalno
        total<<i
      end
    return total
  end
end
