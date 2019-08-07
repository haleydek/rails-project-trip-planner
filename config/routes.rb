Rails.application.routes.draw do
  root 'welcome#home'

  resources :users, only: [:show, :index]

  get '/signup', to: 'users#new'

  post '/signup', to: 'users#create'

  get '/auth/facebook/callback', to: 'sessions#create'

  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
