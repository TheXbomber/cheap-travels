Rails.application.routes.draw do
  resources :reviews
  # profili
  get 'users/profile'
  get 'users/promote_to_moderator'
  get 'users/demote_to_user'
  get 'users/ban_user'
  get 'users/unban_user'
  get 'place/add_to_favourites'
  get 'place/remove_from_favourites'
  #get 'home/dest_update'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # resources :users, only: [:show, :edit, :update]
  #home
  get 'home/index'
  post '/update_dest', to: "home#update_dest" , as: "update_dest"
  post "/results", to: "results#index", as: "search_results"
  # Defines the root path route ("/")
  root "home#index"

  get ":originplace/:checkindate/:checkoutdate/:numpersone/:destcountry/:destiata/:destinationplace", to:"place#index"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/:destcountry/:destiata/:destinationplace/viewmorehotels", to:"place#gethotels"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/:destcountry/:destiata/:destinationplace/viewmoreflights", to:"place#getflights"
  get ":destinationplace/viewmorereviews", to:"place#getreviews"
end
