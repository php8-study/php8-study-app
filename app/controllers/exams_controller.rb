# frozen_string_literal: true

class ExamsController < ApplicationController
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
    @exam = current_user.exams.find(params[:id])

    if @exam.finish!
      redirect_to root_path
    else
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path
  end

  def review
    @exam = current_user.exams.find(params[:id])
    @exam_questions = @exam.exam_questions.includes(:exam_answers).order(position: :asc)
  end
end
