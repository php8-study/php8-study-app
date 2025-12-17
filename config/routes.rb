# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"

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
      get :random, to: "questions/randoms#index"
    end

    resource :solution, only: [:show], module: :questions
  end

  resources :exams, only: [:index, :show, :create] do
    resource :review, only: [:show], module: :exams
    resource :submission, only: [:create], module: :exams

    collection do
      get :check, to: "exams/checks#index"
    end

    resources :exam_questions, only: [:show] do
      resource :answer, only: [:show, :create], module: :exam_questions
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "*path", to: "errors#not_found", via: :all
end
