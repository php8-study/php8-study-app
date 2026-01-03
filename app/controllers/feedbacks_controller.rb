# frozen_string_literal: true

class FeedbacksController < ApplicationController
  skip_before_action :require_login

  def new
    @question_id = params[:question_id]
    respond_to { |f| f.turbo_stream; f.html }
  end

  def create
    @feedback = Feedback.new(
      message: feedback_params[:message],
      question_id: feedback_params[:question_id],
      user: current_user
    )

    if @feedback.save
      flash.now[:notice] = "フィードバックを送信しました"
    else
      flash.now[:alert] = "メッセージを入力してください"
      render status: :unprocessable_content
    end
  end

  private
    def feedback_params
      params.permit(:message, :question_id)
    end
end
