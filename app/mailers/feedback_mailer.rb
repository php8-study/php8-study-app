# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  default to: Rails.application.credentials.dig(:feedback, :admin_email)

  def send_feedback(message:, question_id: nil, user: nil)
    @message = message
    @question_id = question_id
    @user = user

    subject = @question_id ? "【解説FB】問題ID: #{@question_id}" : "【アプリFB】ご意見・ご要望"

    mail(subject: subject) do |format|
      format.text { render plain: body_text }
    end
  end

  private
    def body_text
      <<~TEXT
      ユーザー: #{@user&.id || 'ゲスト'}

      #{@question_id ? "対象問題ID: #{@question_id}" : "全体フィードバック"}
      --------------------------------------------------
      #{@message}
      --------------------------------------------------
      TEXT
    end
end
