# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    if current_user
    # デフォルトの index ビューをレンダリング
    else
      @questions_count = Question.active.count
      render :landing
    end
  end
end
