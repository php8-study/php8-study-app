# frozen_string_literal: true

class ExamQuestionsController < ApplicationController
  before_action :set_exam_question
  before_action :ensure_exam_in_progress, only: %i[show]

  def show
  end

  private
    def set_exam_question
      @exam = current_user.exams.find(params[:exam_id])
      @exam_question = @exam.exam_questions.find(params[:id])
    end

    def ensure_exam_in_progress
      raise ActiveRecord::RecordNotFound if @exam.completed_at
    end
end
