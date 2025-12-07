# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :solution]
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

  def solution
    user_answer_ids = params[:user_answer_ids]
    @is_correct = @question.answer_correct?(user_answer_ids)
    @user_answer_ids = Array(user_answer_ids).map(&:to_i)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end
end
