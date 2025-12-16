# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :solution]
  skip_before_action :require_login, only: [:show, :solution]

  def random
    random_question = Question.active.order("RANDOM()").first
    if random_question.nil?
      redirect_to root_path, alert: "現在利用可能な問題がありません"
    else
      redirect_to question_path(random_question)
    end
  end

  def show
  end

  private
    def set_question
      @question = Question.active.find(params[:id])
    end
end
