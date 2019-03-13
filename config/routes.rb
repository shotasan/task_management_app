Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
end
