require "open-uri"
require 'resolv-replace'
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
            departureTemp >=  params[:minTime] && departureTemp <= params[:maxTime]
        end
     end

     #removing flights without free seats#
     @flights = @flights.find_all do |flight|
       classes = Flighttype.where(:flight_id=>flight.id).pluck(:classname);
       status = false;
       classes.each do |classname|
        total = findTotalSeats(flight.id,classname);
        booked = findBookedSeats(flight.id,params[:jrnydate],classname)
        if(booked.length<total)
             status = true;
         end
       end
       status;
     end
     #adding seats available for each class#
     for i in 0..@flights.length-1 do
       classes = Flighttype.where(:flight_id=>@flights[i].id).pluck(:classname);
       status = false;
       l = 0;
       temp = {};
       classes.each do |classname|
         total = findTotalSeats(@flights[i].id,classname);
         booked = findBookedSeats(@flights[i].id,params[:jrnydate],classname)
         temp[classname] = total-booked.length;
       end
       @flights[i].availableSeatMap = temp;
     end
  end
  def book
    if !@user
      redirect_to '/'
    end
    @flightClasses = Flighttype.joins(:flight).where(:flight_id=>params[:flight_id]).pluck(:classname)
    #filter classes without available seats
    @availableSeats = [];
    @flightClasses = @flightClasses.find_all do |classname|
      total = findTotalSeats(params[:flight_id],classname);
      booked = findBookedSeats(params[:flight_id],params[:jrnydate],classname)
      if(booked.length<total)
           status = true;
           @availableSeats<<(total-booked.length);
      end
      status
    end
    @availbleJavastr = "";
    @flightJavaStr = ""
    @flightClasses.each do|flightClass|
      @flightJavaStr +=flightClass.to_s+","
    end
    @availableSeats.each do |availableSeats|
      @availbleJavastr+=availableSeats.to_s+","
    end
  end

  def confirm
    unless !!@user
      redirect_to '/'
    end
    user = @user
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
       puts passenger
       booked = findBookedSeats(flight_id,doj,params["passenger"][outkey]["class"])
       totalno = findTotalSeats(flight_id,params["passenger"][outkey]["class"])
       total = generateTotalSeats(totalno)
       available = total-booked
       seatno = available.first
       bookdate = Time.now.strftime("%d/%m/%Y")
       addBooking(user.id,bookingno,flight_id,passenger.id,seatno,bookdate,"Booked",doj,params["passenger"][outkey]["class"])
    end
    @flightInfo = Flight.joins(:booking).where("bookings.bookingno"=>bookingno)
    redirect_to "/showTicket?bookingID="+bookingno
  end

  def showTicket
     @bookingID = params[:bookingID]
     @flightInfo = Flight.joins(:booking).where("bookings.bookingno"=>@bookingID)
     @noSeats = Booking.where(:bookingno=>@bookingID).length
     @passengerDet =  Booking.joins(:passenger).where(:bookingno=>@bookingID).select("bookings.*","passengers.*")
  end


  def downloadTicket
    @bookingID = params[:bookingID]
    @flightInfo = Flight.joins(:booking).where("bookings.bookingno"=>@bookingID)
    @noSeats = Booking.where(:bookingno=>@bookingID).length
    @passengerDet =  Booking.joins(:passenger).where(:bookingno=>@bookingID).select("bookings.*","passengers.*")
    kit = PDFKit.new(as_html(@bookingID,@flightInfo,@noSeats,@passengerDet), page_size: 'legal')
    fileTicket = kit.to_file("#{Rails.root}/public/ticket"+@bookingID+".pdf")
    send_file fileTicket
    if(params[:email])
        UsermailerMailer.ticket(@user,"#{Rails.root}/public/ticket"+@bookingID+".pdf","ticket"+@bookingID+".pdf").deliver
    end
  end

  def generateBrochure
    id = params[:bookingID]
    destination = Flight.joins(:booking).where("bookings.bookingno"=>id)
    destination = destination[0].destination
    response = open('https://maps.googleapis.com/maps/api/place/textsearch/json?query=Tourist+spots+in+'+destination+'&key=AIzaSyCQxwpFj_2pTM3i3Ljejzf9KMg8AfwrNTw').read
    response = JSON.parse(response)
    kit = PDFKit.new(as_brochure(response["results"]),page_size:'legal')
    fileBrochure = kit.to_file("#{Rails.root}/public/brochure"+id+".pdf")
    if(params[:email])
        UsermailerMailer.ticket(@user,"#{Rails.root}/public/brochure"+id+".pdf","Brochure"+id+".pdf").deliver
    end
    send_file fileBrochure
  end


  private
  def as_brochure(results)
      render template: "booking/generateBrochure", layout:"application" ,locals: { results: results,pdf: 1}
  end

  def as_html(bookingID,flightInfo,noSeats,passengerDet)
    render template: "booking/generateTicket", layout:"application" ,locals: { bookingID: bookingID,flightInfo: flightInfo,noSeats: noSeats,passengerDet: passengerDet,pdf: 1}
  end
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
