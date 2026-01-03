# frozen_string_literal: true

require "rails_helper"

RSpec.describe Feedback, type: :model do
  let(:test_url) { "https://discord.com/api/webhooks/test_url" }
  let(:params) { { message: "改善要望", question_id: "123", webhook_url: test_url } }
  let(:feedback) { Feedback.new(**params) }

  describe "#save" do
    context "正常な場合" do
      it "trueを返し、期待通りの形式でDiscordに通知すること" do
        expected_content = <<~TEXT
          【フィードバック】
          内容: 改善要望
          対象問題ID: 123
          ユーザーID: ゲスト
        TEXT

        expect(Net::HTTP).to receive(:start).with(
          "discord.com", 443, use_ssl: true, open_timeout: 5, read_timeout: 10
        ).and_yield(double_http = double)

        expect(double_http).to receive(:post).with(
          "/api/webhooks/test_url",
          { content: expected_content }.to_json,
          { "Content-Type" => "application/json" }
        ).and_return(double(value!: true))

        expect(feedback.save).to be true
      end
    end

    context "メッセージが空の場合" do
      let(:params) { { message: "", webhook_url: test_url } }

      it "falseを返し、通知を行わないこと" do
        expect(Net::HTTP).not_to receive(:start)
        expect(feedback.save).to be false
      end
    end

    context "Webhook URLが設定されていない場合" do
      let(:params) { { message: "内容", webhook_url: nil } }

      it "trueを返すが、通知はスキップされること" do
        expect(Net::HTTP).not_to receive(:start)
        expect(feedback.save).to be true
      end
    end
  end
end
