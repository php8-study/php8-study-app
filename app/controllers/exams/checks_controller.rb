# frozen_string_literal: true

module Exams
  class ChecksController < ApplicationController
    def index
      if current_user.active_exam
        @active_exam = current_user.active_exam
        render :check
      else
        render :auto_start
      end
    end
  end
end
