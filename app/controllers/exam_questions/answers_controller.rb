# frozen_string_literal: true

module ExamQuestions
  class AnswersController < ApplicationController
    before_action :set_exam
    before_action :set_exam_question
    before_action :ensure_exam_completed, only: %i[show]

    def show
      respond_to do |format|
        format.turbo_stream { render :show }
      end
    end

    private
      def set_exam
        @exam = current_user.exams.find(params[:exam_id])
      end

      def set_exam_question
        @exam_question = @exam.exam_questions.find(params[:exam_question_id])
      end

      def ensure_exam_completed
        raise ActiveRecord::RecordNotFound unless @exam.completed_at
      end
  end
end
