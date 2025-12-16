# frozen_string_literal: true

module ExamQuestions
  class AnswersController < ApplicationController
    before_action :set_exam
    before_action :set_exam_question
    before_action :ensure_exam_completed, only: %i[show]
    before_action :ensure_exam_in_progress, only: %i[create]

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
        redirect_to review_exam_path(@exam)
      end
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = "回答の保存に失敗しました: #{e.record.errors.full_messages.to_sentence}"
      render :show, status: :unprocessable_entity
    end

    private
      def set_exam
        @exam = current_user.exams.find(params[:exam_id])
      end

      def set_exam_question
        @exam_question = @exam.exam_questions.find(params[:exam_question_id])
      end

      def ensure_exam_in_progress
        raise ActiveRecord::RecordNotFound if @exam.completed_at
      end

      def ensure_exam_completed
        raise ActiveRecord::RecordNotFound unless @exam.completed_at
      end

      def answer_params
        params.permit(question_choice_ids: [])
      end
  end
end
