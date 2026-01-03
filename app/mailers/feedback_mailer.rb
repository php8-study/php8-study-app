# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  def send_feedback(message:, question_id: nil, user: nil, admin_email: Rails.application.credentials.dig(:feedback, :admin_email))
    @message = message
    @question_id = question_id
    @user = user

    subject = @question_id.present? ? "【解説FB】問題ID: #{@question_id}" : "【アプリFB】ご意見・ご要望"

    mail(to: admin_email, subject: subject)
  end
end
