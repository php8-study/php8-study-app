# frozen_string_literal: true

class Questions::SolutionsController < ApplicationController
  before_action :set_question, only: [:show]
  skip_before_action :require_login, only: [:show]

  def show
    user_answer_ids = params[:user_answer_ids]
    if user_answer_ids.present?
      @is_correct = @question.answer_correct?(user_answer_ids)
      @user_answer_ids = Array(user_answer_ids).map(&:to_i)
    end
  end

  private
    def set_question
      @question = Question.active.find(params[:question_id])
    end
end
