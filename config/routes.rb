Rails.application.routes.draw do
  root "plans#index"
  devise_for :users
  namespace :users do
    resources :plans
  end
  resources :plans, only: [:show]
end
