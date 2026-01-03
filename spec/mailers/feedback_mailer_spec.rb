# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackMailer, type: :mailer do
  describe "send_feedback" do
    let(:message) { "テストメッセージ" }
    let(:admin_email) { "admin@example.com" }

    it "解説フィードバック：件名と本文に問題IDが含まれること" do
      mail = FeedbackMailer.send_feedback(message: message, question_id: "123", admin_email: admin_email)

      expect(mail.to).to eq [admin_email]
      expect(mail.subject).to eq "【解説FB】問題ID: 123"
      expect(mail.body.encoded).to include("対象問題ID: 123")
      expect(mail.body.encoded).to include(message)
    end

    it "アプリフィードバック：件名がアプリFB用になること" do
      mail = FeedbackMailer.send_feedback(message: message, question_id: nil, admin_email: admin_email)

      expect(mail.to).to eq [admin_email]
      expect(mail.subject).to eq "【アプリFB】ご意見・ご要望"
      expect(mail.body.encoded).to include("全体フィードバック")
    end
  end
end
