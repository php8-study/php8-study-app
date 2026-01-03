# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  describe "POST /feedbacks" do
    context "正常系" do
      it "送信成功のレスポンスが返り、完了メッセージが表示されること" do
        allow_any_instance_of(Feedback).to receive(:save).and_return(true)

        post feedbacks_path, params: { message: "テスト内容" }, as: :turbo_stream

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("送信しました")
      end
    end

    context "異常系" do
      it "メッセージが空ならバリデーションエラー（422）になること" do
        post feedbacks_path, params: { message: "" }, as: :turbo_stream
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
