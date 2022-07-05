Rails.application.routes.draw do
  get 'users/profile' # Alessandro
  devise_for :users   # Alessandro
  get 'home/index'    # Alessandro

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/results", to: "results#index"
  get '/airport', to: 'home#airport' 
  post '/airport', to: 'home#airport' 

  put "/send_results", to: "results#index", as: 'send_results'  
 
  # Defines the root path route ("/")
  root "home#index"

  get ":originplace/:checkindate/:checkoutdate/:numpersone/place/:destinationplace", to:"place#index"
  get ":checkindate/:checkoutdate/:numpersone/place/:name", to:"place#index"
  get ":checkindate/:checkoutdate/:numpersone/place/:name/viewmorehotels", to:"place#viewmorehotels

end
