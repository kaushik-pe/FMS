class BookingController < ApplicationController
  def homepage
  end
  def list
     puts params
     source = params[:source]
     destination = params[:destination]
     jrnydate = params[:jrnydate]
     dateQuery = "schedules."+Date.parse(jrnydate).strftime("%A").downcase
     unless params[:sortby]
       @flights = Flight.joins(:schedule).where(:source=>params[:source],:destination=>params[:destination],dateQuery=>'t')
     end
     if params[:sortby]
       attribute = params[:sortby].to_sym
       @flights = Flight.where(:source=>params[:source],:destination=>params[:destination]).order(attribute)
     end
  end
end
