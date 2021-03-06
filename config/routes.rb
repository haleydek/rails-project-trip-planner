Rails.application.routes.draw do
  root 'welcome#home'

  resources :users do
    resources :trips
    resources :users_trips, only: [:update]
  end

  resources :destinations, only: [:index]

  resources :users, only: [:show]

  get '/signup', to: 'users#new'

  post '/signup', to: 'users#create'

  get '/auth/facebook/callback', to: 'sessions#create'

  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  get '/destinations/most_popular', to: 'destinations#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
