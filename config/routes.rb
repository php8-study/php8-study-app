# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :admin do
    get "/", to: "home#index"
    resources :questions
    resources :categories do
      member do
        get :render_row
      end
    end
  end

  resources :questions, only: [:show] do
    get "random", on: :collection
    member do
      get "solution"
    end
  end

  resources :exams, only: [:create, :index] do
    post "submissions", to: "exams#submit", on: :member
    get "check", on: :collection

    resources :submissions, only: [:create]

    resources :exam_questions, only: [:show] do
      get "review", on: :member
      post "answer", on: :member
    end
  end
end
