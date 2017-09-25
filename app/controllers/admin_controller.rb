class AdminController < ApplicationController
  before_action :checkAdmin
  def profile

  end
  def showUsers
    @allUsers = User.all
  end
  def userDelete
    @temp = User.find(params[:userid])
    @temp.destroy
    redirect_to '/profile/admin/viewUsers'
  end
  def addFlight
  end
  def createFlight
    days = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
    days.each do |day|
      if params[day]
        params[day] = "t"
      else
        params[day] = "f"
      end
    end
    flight = Flight.create(:source=>params[:source],:destination=>params[:destination],:airlines=>params[:airlines],:arrival_time=>params[:arrival_time],:departure_time=>params[:departure_time])
    Schedule.create(:flight_id=>flight.id,:monday=>params[:monday],:tuesday=>params[:tuesday],:wednesday=>params[:wednesday],:thursday=>params[:thursday],:friday=>params[:friday],:saturday=>params[:saturday],:sunday=>params[:sunday])
    redirect_to '/profile/admin/addFlightClass?flight_id='+flight.id.to_s
  end
  def createFlightClass
    temp = Hash.new
    params["flighttype"].each do |outkey,outvalue|
      temp = Hash.new
      params["flighttype"][outkey].permit(:classname,:noofseats,:price).each do|key,value|
        key = key.to_sym
        temp[key] = value
      end
       temp[:flight_id] = params[:flight_id]
       Flighttype.create(temp)
    end
    redirect_to '/'
  end
  private
  def checkAdmin
    if(!@user)
      redirect_to '/'
    end
    if(!@user.isadmin)
      redirect_to '/profile'
    end
  end
end
