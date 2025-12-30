# frozen_string_literal: true

module Exams
  class SubmissionsController < ApplicationController
    before_action :set_exam

    def create
      @exam.finish!
      redirect_to exam_path(@exam, reveal: true)
    end

    private
      def set_exam
        @exam = current_user.exams.in_progress.find(params[:exam_id])
      end
  end
end
