Rails.application.routes.draw do
  root "tasks#index"
  namespace :admin do
    resources :users
    resources :labels
  end
  resources :tasks
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
end
