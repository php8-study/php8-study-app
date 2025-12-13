# frozen_string_literal: true

Rails.application.routes.draw do
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"

  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/auth/github/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :admin do
    root to: "home#index"

    resources :questions

    resources :categories do
      member do
        get :render_row
      end
    end
  end

  resources :questions, only: [:show] do
    collection do
      get :random
    end

    member do
      get :solution
    end
  end

  resources :exams, only: [:index, :show, :create] do
    collection do
      get :check
    end

    member do
      get :review
      post :submissions, to: "exams#submit"
    end

    resources :exam_questions, only: [:show] do
      member do
        post :answer
        get :solution
      end
    end
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  match "*path", to: "errors#not_found", via: :all
end
