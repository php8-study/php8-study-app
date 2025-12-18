# frozen_string_literal: true

module Exams
  class ReviewsController < ApplicationController
    before_action :set_exam
    before_action :ensure_in_progress

    def show
      @exam_questions = @exam.exam_questions
                             .includes(:exam_answers, question: :question_choices)
                             .order(position: :asc)
    end

    private
      def set_exam
        @exam = current_user.exams.find(params[:exam_id])
      end

      def ensure_in_progress
        raise ActiveRecord::RecordNotFound if @exam.completed_at
      end
  end
end
