class UserController < ApplicationController
  def signup
    @user = User.create(:name=>params[:name],:emailid=>params[:username],:password=>params[:password],:contactno=>params[:contactno],:verified=>true,:isadmin=>false,:credate=>Time.now().to_s)
    session[:emailid] = @user.emailid
    redirect_to '/'
  end
  def login
    puts params
    @user = User.where(:emailid=>params[:username],:password=>params[:password]);
    if !!@user[0]
      puts "found user"
      session[:emailid] = @user[0].emailid
    end
    redirect_to '/'
  end
  def logout
    session[:emailid] = nil
    redirect_to '/'
  end
  def profile
    if(@user.isadmin)
      redirect_to '/profile/admin'
    end
  end
  def showBookings
    puts @user.id
    @bookings = Booking.joins(:flight).where(:user_id=>@user.id).group(:bookingno).select("bookings.*","flights.*")
  end
  def viewPassengerInfo
    @bookingno = params[:bookingno]
    @status = Booking.where(:bookingno=>@bookingno).group(:bookingno)[0].status
    @passengerDetails = Booking.joins(:passenger).where(:bookingno=>@bookingno).select("bookings.*","passengers.*")
  end
  def cancelBooking
    Booking.where(:bookingno=>params[:bookingno]).update(:status=>"Cancelled")
    redirect_to "/profile/bookings"
  end
  def updateProfile
     session[:emailid] = params[:emailid]
     User.where(:id=>@user.id).update(:name=>params[:name],:emailid=>params[:emailid],:contactno=>params[:contactno]);
     redirect_to "/profile"
  end
end
