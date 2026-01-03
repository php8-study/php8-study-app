# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  describe "POST /feedbacks" do
    context "正常系" do
      it "送信成功のレスポンスが返り、メールが送信されること" do
        mail = FeedbackMailer.send_feedback(message: "内容", admin_email: "admin@example.com")
        allow(FeedbackMailer).to receive(:send_feedback).and_return(mail)

        expect {
          post feedbacks_path, params: { message: "内容", question_id: "1" }, as: :turbo_stream
        }.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("送信しました")
      end
    end

    context "異常系" do
      it "メッセージが空なら 422 を返すこと" do
        post feedbacks_path, params: { message: "", question_id: "1" }, as: :turbo_stream
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
