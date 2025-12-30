# frozen_string_literal: true

class ExamQuestionsController < ApplicationController
  before_action :set_exam_question

  def show
  end

  private
    def set_exam_question
      @exam = current_user.exams.in_progress.find(params[:exam_id])
      @exam_question = @exam.exam_questions.find(params[:id])
    end
end
