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
    resource :password, only: [:new, :create, :edit, :password]
    patch "/password", to: "passwords#update"
    get "/plans_published", to: "plans#published"
    get "/plans_draft", to: "plans#draft"
    get "/suggest_spot", to: "plans#suggest_spot"
    post "/spots", to: "spots#create"
    post "/photos", to: "photos#create"
    get "/unsubscribe", to: "unsubscribe#show"
    patch "/level_up", to: "level_up#update"
  end

  resources :users, module: :users, param: :name, path: "/", only: [] do
    resource :profile, only: [:show], controller: "profiles"
    get "/likes", to: "profiles#like"
    get "/trophies", to: "profiles#trophy"
    get "/followers", to: "profiles#followers"
    get "/following", to: "profiles#following"
    resource :relationship, only: [:create, :destroy]
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
