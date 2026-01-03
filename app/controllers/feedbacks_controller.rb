# frozen_string_literal: true

class FeedbacksController < ApplicationController
  skip_before_action :require_login

  def new
    @question_id = params[:question_id]
  end

  def create
    @message = feedback_params[:message]
    question_id = feedback_params[:question_id]

    if @message.present?
      FeedbackMailer.send_feedback(
        message: @message,
        question_id: question_id,
        user: current_user
      ).deliver_now

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
