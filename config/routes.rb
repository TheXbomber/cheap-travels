Rails.application.routes.draw do
  # profili
  get 'users/profile'
  devise_for :users
  #home
  get 'home/index'
  post "/results", to: "results#index", as: "search_results"
  get "/results/:origin/:departure/:people", to: "results#index", as: "searchget"
  # Defines the root path route ("/")
  root "home#index"

  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace", to:"place#index"
  get ":checkindate/:checkoutdate/:numpersone/place/:name", to:"place#index"
  get ":checkindate/:checkoutdate/:numpersone/place/:name/viewmorehotels", to:"place#viewmorehotels"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace/viewmorehotels", to:"place#gethotels"
  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace/viewmoreflights", to:"place#getflights"

end
