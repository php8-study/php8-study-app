# frozen_string_literal: true

Rails.application.routes.draw do
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
end
