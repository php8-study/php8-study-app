# frozen_string_literal: true

class QuestionsController < ApplicationController
  include GuestTrialLimitable

  skip_before_action :require_login, only: [:show]
  before_action :check_guest_trial_limit, only: [:show]

  def show
    @question = Question.active.find(params[:id])
  end
end
