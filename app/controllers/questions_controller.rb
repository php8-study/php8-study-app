# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :solution]
  def random
    random_question = Question.order("RANDOM()").first
    redirect_to question_path(random_question)
  end

  def show
  end

  def solution
    @user_answer_ids = params[:user_answer_ids].to_a.map(&:to_i)
    @correct_answer_ids = @question.question_choices.where(correct: true).pluck(:id)

    @is_correct = (@user_answer_ids.sort == @correct_answer_ids.sort)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end
end
