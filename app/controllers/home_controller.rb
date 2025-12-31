# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    unless current_user
      @questions_count = Rails.cache.fetch("active_questions_count", expires_in: 1.hour) do
        Question.active.count
      end
      render :landing
    end
  end
end
