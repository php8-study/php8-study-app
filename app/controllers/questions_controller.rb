# frozen_string_literal: true

class QuestionsController < ApplicationController
  skip_before_action :require_login

  def show
    @question = Question.active.find(params[:id])
  end
end
