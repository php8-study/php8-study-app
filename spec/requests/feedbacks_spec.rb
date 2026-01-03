# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  describe "POST /feedbacks" do
    let(:valid_params) { { message: "テストメッセージ", question_id: "123" } }

    context "正常系" do
      it "メール送信処理が実行され、正常なレスポンスが返ること" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(FeedbackMailer).to receive(:send_feedback).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_now)

        post feedbacks_path, params: valid_params, as: :turbo_stream

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("送信しました")
      end
    end

    context "異常系" do
      it "メッセージが空の場合、422エラーを返すこと" do
        post feedbacks_path, params: { message: "", question_id: "123" }, as: :turbo_stream
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
