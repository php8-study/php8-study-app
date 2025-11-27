# frozen_string_literal: true

class ExamQuestionsController < ApplicationController
  before_action :set_exam_question, only: [:show, :answer]

  def show
    @exam_answers = @exam_question.exam_answers.to_a
    @question = @exam_question.question
  end

  def answer
    @exam = current_user.exams.find(params[:exam_id])
    @exam_question = @exam.exam_questions.find(params[:id])

    choice_ids = answer_params[:question_choice_ids] || []

    ExamAnswer.transaction do
      @exam_question.exam_answers.destroy_all

      choice_ids.each do |choice_id|
        @exam_question.exam_answers.create!(question_choice_id: choice_id)
      end
    end

    next_question = @exam_question.next_question

    if next_question.present?
      redirect_to exam_exam_question_path(@exam, next_question)
    else
      redirect_to review_exam_path(@exam)
    end

  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "回答の保存に失敗しました: #{e.record.errors.full_messages.to_sentence}"
    render :show, status: :unprocessable_entity
  end

  private
    def set_exam_question
      @exam = current_user.exams.find(params[:exam_id])
      @exam_question = @exam.exam_questions.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "指定された試験または問題は見つかりませんでした。"
    end

    def answer_params
      params.permit(question_choice_ids: [])
    end
end
