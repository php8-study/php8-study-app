# frozen_string_literal: true

class ExamsController < ApplicationController
  before_action :set_exam, only: %i[show]
  before_action :ensure_completed, only: %i[show]

  def index
    @exams = current_user.exams
                         .where.not(completed_at: nil)
                         .preload(exam_questions: [{ question: :question_choices }, :exam_answers])
                         .order(completed_at: :desc)
  end

  def new
    return render :resume_confirmation if (@active_exam = current_user.active_exam)
  end

  def show
    @exam_questions = @exam.exam_questions
    @needs_reveal_animation = params[:reveal].present?
  end

  def create
    exam = Exam::Starter.new(user: current_user).call

    redirect_to exam_exam_question_path(exam, exam.exam_questions.first)
  end

  private
    # 使用アクションが増えたら関連読み込みが適切か確認する事
    def set_exam
      @exam = current_user.exams
                          .preload(exam_questions: [{ question: [:question_choices, :category] }, :exam_answers])
                          .find(params[:id])
    end

    def ensure_completed
      raise ActiveRecord::RecordNotFound unless @exam.completed_at
    end
end
