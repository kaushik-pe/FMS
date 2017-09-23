Rails.application.routes.draw do
  get 'booking/homepage'

  get 'list' => "booking#list"
  get 'book' => "booking#book"
  post 'confirm' =>"booking#confirm"
  get 'showTicket'=>"booking#showTicket"
  root 'booking#homepage'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
