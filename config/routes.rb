Rails.application.routes.draw do
  resources :reviews
  # profili
  get 'users/profile'
  get 'users/promote_to_moderator'
  get 'users/demote_to_user'
  get 'place/add_to_favourites'
  get 'place/remove_from_favourites'
  devise_for :users
  # resources :users, only: [:show, :edit, :update]
  #home
  get 'home/index'
  post "/results", to: "results#index", as: "search_results"
  # Defines the root path route ("/")
  root "home#index"

  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace", to:"place#index"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace/viewmorehotels", to:"place#gethotels"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace/viewmoreflights", to:"place#getflights"
  get ":destinationplace/viewmorereviews", to:"place#getreviews"
end
