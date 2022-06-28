Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/results", to: "results#index"
  # Defines the root path route ("/")
  root "home#index"

  get "/place/:name", to:"place#index"
end
