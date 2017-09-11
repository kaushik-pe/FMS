Rails.application.routes.draw do
  get 'flights/new'

  get 'welcome/homepage'
  root 'welcome#homepage'
  resources :flights
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
