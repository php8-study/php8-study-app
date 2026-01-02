# frozen_string_literal: true

class FeedbacksController < ApplicationController
  def new
    @question_id = params[:question_id]
  end

  def create
    @message = params[:message]
    question_id = params[:question_id]

    if @message.present?
      FeedbackMailer.send_feedback(
        message: @message,
        question_id: question_id,
        user: (current_user if defined?(current_user))
      ).deliver_later

      flash.now[:notice] = "フィードバックを送信しました"
    else
      flash.now[:alert] = "メッセージを入力してください"
      render status: :unprocessable_entity
    end
  end
end
