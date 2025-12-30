# frozen_string_literal: true

module Exams
  class ReviewsController < ApplicationController
    before_action :set_exam

    def show
      @exam_questions = @exam.exam_questions
                             .preload(:exam_answers, question: :question_choices)
                             .order(position: :asc)
    end

    private
      def set_exam
        @exam = current_user.exams.in_progress.find(params[:exam_id])
      end
  end
end
