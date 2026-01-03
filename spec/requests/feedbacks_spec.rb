# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  let(:admin_email) { "admin@example.com" }

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:feedback, :admin_email).and_return(admin_email)
  end

  describe "GET /feedbacks/new" do
    it "ログイン・未ログインにかかわらず、モーダル表示用のTurbo Streamを返すこと" do
      get new_feedback_path, as: :turbo_stream
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('turbo-stream action="append" target="modal-frame"')
      expect(response.body).to include("フィードバック送信")
    end
  end

  describe "POST /feedbacks" do
    context "正常系：パラメータが有効な場合" do
      let(:valid_params) { { message: "テストメッセージ", question_id: "123" } }

      it "ログインユーザーとしてメールを送信できること" do
        user = create(:user)
        sign_in_as(user)

        expect {
          post feedbacks_path, params: valid_params, as: :turbo_stream
        }.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("送信しました")
      end

      it "未ログイン（ゲスト）としてメールを送信できること" do
        expect {
          post feedbacks_path, params: valid_params, as: :turbo_stream
        }.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("送信しました")
      end
    end

    context "異常系：メッセージが空の場合" do
      let(:invalid_params) { { message: "", question_id: "123" } }

      it "メールを送信せず、バリデーションエラーを返すこと" do
        expect {
          post feedbacks_path, params: invalid_params, as: :turbo_stream
        }.not_to change { ActionMailer::Base.deliveries.size }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("入力してください")
      end
    end
  end
end
