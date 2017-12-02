Rails.application.routes.draw do
  root "plans#index"
  devise_for :users
  resources :plans, only: [:show, :new, :create, :edit, :update, :destroy]
end
