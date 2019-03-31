Rails.application.routes.draw do
  root "tasks#index"
  namespace :admin do
    resources :users
    resources :labels, only: [:index, :create, :destroy]
  end
  resources :tasks
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
end
