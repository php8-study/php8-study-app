# frozen_string_literal: true

class ExamsController < ApplicationController
  before_action :set_exam, only: %i[show submit review]

  def index
    @exams = current_user.exams
                         .where.not(completed_at: nil)
                         .includes(exam_questions: [{ question: :question_choices }, :exam_answers])
                         .order(completed_at: :desc)
  end

  def show
    @exam_questions = @exam.exam_questions
                           .includes({ question: [:question_choices, :category] }, :exam_answers)
                           .order(:position)

    @needs_reveal_animation = params[:reveal].present?
  end

  def check
    if current_user.active_exam
      @active_exam = current_user.active_exam
      render :check
    else
      render :auto_start
    end
  end

  def create
    exam = Exam::Start.new(user: current_user).call

    redirect_to exam_exam_question_path(exam, exam.exam_questions.first)
  rescue => e
    Rails.logger.error "Exam Start Failed: #{e.message}\n#{e.backtrace.join("\n")}"
    redirect_to root_path
  end

  def submit
    if @exam.finish!
      redirect_to exam_path(@exam, reveal: true)
    else
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path
  end

  def review
    @exam_questions = @exam.exam_questions.includes(:exam_answers).order(position: :asc)
  end

  private
    def set_exam
      @exam = current_user.exams
                          .includes(exam_questions: [{ question: :question_choices }, :exam_answers])
                          .find(params[:id])
    end
end
