Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    confirmations: "users/confirmations"
  }
  root to: "home#index"

  get "members/:id", to: "members#show", as: "member"
  get "edit_description", to: "members#edit_description", as: "edit_member_description"
  patch "update_description", to: "members#update_description", as: "update_member_description"
  get "edit_personal_details", to: "members#edit_personal_details", as: "edit_member_personal_details"
  patch "update_personal_details", to: "members#update_personal_details", as: "update_member_personal_details"
  get "member-connections/:id", to: "members#connections", as: "member_connections"

  resources :work_experiences
  resources :connections

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
