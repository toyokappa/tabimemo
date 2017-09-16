Rails.application.routes.draw do
  root "plans#index"

  resources :plans, only: [:show, :new, :create, :edit, :update, :destroy]
end
