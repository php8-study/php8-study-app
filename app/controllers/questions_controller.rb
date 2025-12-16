# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question
  skip_before_action :require_login

  def show
    @question = Question.active.find(params[:id])
  end
end
