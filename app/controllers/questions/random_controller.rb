# frozen_string_literal: true

module Questions
  class RandomController < ApplicationController
    skip_before_action :require_login, only: [:show]
    
    def show
      random_question = Question.active.order("RANDOM()").first
      if random_question.nil?
        redirect_to root_path, alert: "現在利用可能な問題がありません"
      else
        redirect_to question_path(random_question)
      end
    end
  end
end
