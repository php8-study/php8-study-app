# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackMailer, type: :mailer do
  describe "send_feedback" do
    let(:message) { "テストメッセージです" }
    let(:admin_email) { "admin@example.com" }

    before do
      allow(Rails.application.credentials).to receive(:dig).with(:feedback, :admin_email).and_return(admin_email)
    end

    context "問題IDがある場合（解説フィードバック）" do
      let(:question_id) { "123" }
      let(:mail) { FeedbackMailer.send_feedback(message: message, question_id: question_id, user: nil) }

      it "件名に問題IDが含まれ、本文が対象問題用の表記であること" do
        expect(mail.subject).to eq "【解説FB】問題ID: 123"
        expect(mail.body.encoded).to include("対象問題ID: 123")
      end
    end

    context "問題IDがない場合（アプリフィードバック）" do
      let(:mail) { FeedbackMailer.send_feedback(message: message, question_id: nil, user: nil) }

      it "件名がアプリFB用になり、本文が全体フィードバックの表記であること" do
        expect(mail.subject).to eq "【アプリFB】ご意見・ご要望"
        expect(mail.body.encoded).to include("全体フィードバック")
      end
    end

    context "ユーザー情報の表示" do
      it "ログインユーザーの場合、そのIDが表示されること" do
        user = create(:user)
        mail = FeedbackMailer.send_feedback(message: message, user: user)
        expect(mail.body.encoded).to include("ユーザー: #{user.id}")
      end

      it "ゲストの場合、『ゲスト』と表示されること" do
        mail = FeedbackMailer.send_feedback(message: message, user: nil)
        expect(mail.body.encoded).to include("ユーザー: ゲスト")
      end
    end
  end
end
