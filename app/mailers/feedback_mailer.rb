# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  def send_feedback(message:, question_id: nil, user: nil, admin_email: Rails.application.credentials.dig(:feedback, :admin_email))
    subject = question_id.present? ? "【解説FB】問題ID: #{question_id}" : "【アプリFB】ご意見・ご要望"

    body = <<~TEXT
      #{question_id.present? ? "対象問題ID: #{question_id}" : "全体フィードバック"}
      ユーザー: #{user&.id || 'ゲスト'}

      内容:
      #{message}
    TEXT

    mail(to: admin_email, subject: subject, body: body)
  end
end
