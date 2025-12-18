# frozen_string_literal: true

class Questions::SolutionsController < ApplicationController
  before_action :set_question, only: [:show]
  skip_before_action :require_login, only: [:show]

  def show
    @user_answer_ids = parsed_answer_ids
    @is_correct = @question.answer_correct?(@user_answer_ids)
  end

  private
    def set_question
      @question = Question.active.find(params[:question_id])
    end

    def parsed_answer_ids
      Array(params[:user_answer_ids]).map(&:to_i)
    end
end
