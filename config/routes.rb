Rails.application.routes.draw do
  root "plans#index"
  devise_for :users
  namespace :users do
    resources :plans
    resource :profile, only: [:show, :new, :create, :edit, :update]
  end
  resources :plans, only: [:show]
end
