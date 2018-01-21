Rails.application.routes.draw do
  root "plans#index"
  devise_for :users, controllers: { registrations: "users/registrations" }
  namespace :users do
    resources :plans, only: [:index, :new, :create, :edit, :update, :destroy]
    resource :profile, only: [:new, :create, :edit, :update]
    get "/password", to: "passwords#edit"
    put "/password", to: "passowrds#update"
    patch "/password", to: "passwords#update"
    get "/create_spot", to: "plans#create_spot"
    get "/suggest_spot", to: "plans#suggest_spot"
    post "/photos", to: "photos#create"
  end

  resources :users, param: :name, path: "/", only: [] do
    resource :profile, only: [:show], controller: "users/profiles"
  end

  resources :plans, only: [:show]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
end
