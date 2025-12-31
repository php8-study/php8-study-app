# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    @questions_count = Question.active.count
    render :landing unless current_user
  end
end
