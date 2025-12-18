# frozen_string_literal: true

module Exams
  class SubmissionsController < ApplicationController
    before_action :set_exam
    before_action :ensure_in_progress

    def create
      @exam.finish!
      redirect_to exam_path(@exam, reveal: true)
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
