class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :is_authenticated
  def is_authenticated
    if !!session[:emailid]
      temp = User.where(:emailid=>session[:emailid])
      @user = temp[0]
    end
  end
end
