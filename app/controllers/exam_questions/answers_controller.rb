# frozen_string_literal: true

module ExamQuestions
  class AnswersController < ApplicationController
    before_action :set_completed_exam_question, only: %i[show]
    before_action :set_in_progress_exam_question, only: %i[create]

    def show
      respond_to do |format|
        format.turbo_stream { render :show }
      end
    end

    def create
      @exam_question.save_answers!(answer_params[:question_choice_ids])

      if (next_q = @exam_question.next_question)
        redirect_to exam_exam_question_path(@exam, next_q)
      else
        redirect_to exam_review_path(@exam)
      end
    end

    private
      def set_in_progress_exam_question
        @exam = current_user.exams.in_progress.find(params[:exam_id])
        @exam_question = @exam.exam_questions.find(params[:exam_question_id])
      end

      def set_completed_exam_question
        @exam = current_user.exams.completed.find(params[:exam_id])
        @exam_question = @exam.exam_questions.find(params[:exam_question_id])
      end

      def answer_params
        params.permit(question_choice_ids: [])
      end
  end
end
