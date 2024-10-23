Rails.application.routes.draw do
  root "top#index"
  get "top/index" # TOPページ
  post "login", to: "user_sessions#create" # ログインする
  get "login", to: "user_sessions#new" # ログイン画面を表示
  delete "logout", to: "user_sessions#destroy"

  resources :users, only: %i[new create]
  resources :memos, only: %i[new create] do
    post :confirm, on: :collection
    get :confirm, on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
