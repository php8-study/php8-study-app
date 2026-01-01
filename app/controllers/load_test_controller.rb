# frozen_string_literal: true

class LoadTestController < ApplicationController
  skip_before_action :require_login, raise: false # 認証スキップ
  skip_forgery_protection                         # CSRFスキップ

  before_action :set_no_cache

  def read
    question = Question.includes(:question_choices).order("RANDOM()").first

    if question
      render json: { id: question.id, choices: question.question_choices.size }
    else
      render json: { status: "no data" }
    end
  end

  def write
    ActiveRecord::Base.transaction do
      sleep(0.05)


      question = Question.first
      question.touch if question
    end

    render plain: "Written!"
  end

  private
    def set_no_cache
      response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "0"
    end
end
