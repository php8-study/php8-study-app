# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  describe "POST /feedbacks" do
    context "正常系" do
      it "実際にメールが送信され、送信リストが増えること" do
        expect {
          post feedbacks_path, params: { message: "テスト内容", question_id: "1" }, as: :turbo_stream
        }.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("送信しました")

        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq ["admin@example.com"]
        expect(email.subject).to include("問題ID: 1")
      end
    end

    context "異常系" do
      it "メッセージが空なら送信されないこと" do
        expect {
          post feedbacks_path, params: { message: "" }, as: :turbo_stream
        }.not_to change { ActionMailer::Base.deliveries.size }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
