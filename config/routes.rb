Rails.application.routes.draw do
  resources :wallets
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  #
  #


  get "home/index"
  root to: "home#index"

  post "home/create_wallet"
  get "home/create_wallet"

end
