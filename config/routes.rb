Rails.application.routes.draw do
  get 'homepage/index'
  post 'shorten', to: 'shorten#create'
  root to: 'homepage#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
