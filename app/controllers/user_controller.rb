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
end
