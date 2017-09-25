Rails.application.routes.draw do
  get 'booking/homepage'
  get 'list' => "booking#list"
  get 'book' => "booking#book"
  post 'confirm' =>"booking#confirm"
  get 'showTicket'=>"booking#showTicket"
  get 'downloadTicket'=>"booking#downloadTicket"
  get 'generateBrochure'=>"booking#generateBrochure"
  post 'signup'=>'user#signup'
  post 'login'=>'user#login'
  get 'logout'=>'user#logout'
  get 'profile'=>'user#profile'
  get 'profile/bookings'=>'user#showBookings'
  get '/profile/booking/viewPassengerInfo'=>'user#viewPassengerInfo'
  get '/profile/cancelBooking'=>'user#cancelBooking'
  get '/profile/edit'=>'user#edit'
  get '/profile/admin'=>"admin#profile"
  get '/profile/admin/viewUsers'=>'admin#showUsers'
  get '/profile/admin/userDelete'=>'admin#userDelete'
  get '/profile/admin/addFlights'=>'admin#addFlight'
  get '/profile/admin/addFlightClass'=>'admin#addFlightClass'
  post '/profile/admin/createFlight'=>'admin#createFlight'
  post '/profile/update'=>'user#updateProfile'
  post "/profile/admin/createFlightClass"=>'admin#createFlightClass'
  root 'booking#homepage'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
