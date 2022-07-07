Rails.application.routes.draw do
  resources :reviews
  # profili
  get 'users/profile'
  get 'place/add_to_favourites'
  get 'place/remove_from_favourites'
  devise_for :users
  # resources :users, only: [:show, :edit, :update]
  #home
  get 'home/index'

  get "/results", to: "results#index"
  get '/airport', to: 'home#airport' 
  post '/airport', to: 'home#airport' 

  put "/send_results", to: "results#index", as: 'send_results'  
 
  # Defines the root path route ("/")
  root "home#index"

  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace", to:"place#index"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace", to:"place#add_favourites"
  # get ":checkindate/:checkoutdate/:numpersone/place/:name", to:"place#index"
  # get ":checkindate/:checkoutdate/:numpersone/place/:name/viewmorehotels", to:"place#viewmorehotels"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace/viewmorehotels", to:"place#gethotels"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace/viewmoreflights", to:"place#getflights"

end
