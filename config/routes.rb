Rails.application.routes.draw do
  root "welcome#index"
  devise_for :users, controllers: { 
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  namespace :users do
    resources :plans, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :social_accounts, only: [:destroy]
    resource :profile, only: [:edit, :update]
    resource :notification, only: [:edit, :update]
    get "/password", to: "passwords#edit"
    put "/password", to: "passowrds#update"
    patch "/password", to: "passwords#update"
    get "/plans_published", to: "plans#published"
    get "/plans_draft", to: "plans#draft"
    get "/suggest_spot", to: "plans#suggest_spot"
    get "/translate_spot", to: "plans#translate_spot"
    post "/spots", to: "spots#create"
    post "/photos", to: "photos#create"
    get "/unsubscribe", to: "unsubscribe#show"
  end

  resources :users, param: :name, path: "/", only: [] do
    resource :profile, only: [:show], controller: "users/profiles"
    get "/liked_plans", to: "users/profiles#liked"
  end

  resources :plans, only: [:index, :show]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
  get "/search", to: "search#index"
  get "/terms", to: "static#terms"
  get "/privacy_policy", to: "static#privacy_policy"
  post "/opinions", to: "opinions#create"

  get "/batch/save_page_views", to: "batch/save_page_views#exec"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
