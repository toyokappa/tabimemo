Rails.application.routes.draw do
  root "plans#index"

  resources :plans, only: [:show, :new, :create, :edit, :update, :destroy] do
    collection do
      match "search" => "plans#search", via: [:get, :post], as: :search
    end
  end
end
