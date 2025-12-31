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
    resources :questions, except: [:show]
    resources :categories
  end

  namespace :questions do
    resource :random, only: [:show], controller: :random
  end

  resources :questions, only: [:show] do
    resource :solution, only: [:show], module: :questions
  end

  resources :exams, only: [:index, :new, :show, :create] do
    scope module: :exams do
      resource :review, only: [:show]
      resource :submission, only: [:create]
    end

    resources :exam_questions, only: [:show] do
      resource :answer, only: [:show, :create], module: :exam_questions
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  # 負荷テスト用（検証が終わったら必ず消すこと！）
  get  "/load_test/read",  to: "load_test#read"
  post "/load_test/write", to: "load_test#write"
end
