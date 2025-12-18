# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  get "/auth/github/callback", to: "sessions#create"

  resource :session, only: [:destroy]


  if Rails.env.development?
    namespace :development do
      post "login_as/:user_id", to: "sessions#sign_in_as", as: :login_as
    end
  end

  with_options only: :show do
    resource :terms, controller: :terms
    resource :privacy, controller: :privacy
  end

  namespace :admin do
    root to: "home#index"
    resources :questions
    resources :categories
  end

  namespace :questions do
    resource :random, only: [:show], controller: :random
  end

  resources :questions, only: [:show] do
    scope module: :questions do
      resource :solution, only: [:show]
    end
  end

  resources :exams, only: [:index, :show, :create] do
    scope module: :exams do
      resource :review, only: [:show]
      resource :submission, only: [:create]

      collection do
        get :check, to: "checks#index"
      end
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
