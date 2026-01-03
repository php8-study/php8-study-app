# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  describe "POST /feedbacks" do
    context "正常系" do
      it "送信成功のレスポンスが返り、メールが送信リストに追加されること" do
        # Railsが内部で使っている Mail オブジェクトを直接生成
        # これにより、テンプレートファイル (.erb) を探す処理をスキップできます
        dummy_mail = Mail.new(to: "admin@example.com", subject: "stub", body: "stub")
        
        # deliver_now メソッドを呼び出せるようにスタブを追加
        allow(dummy_mail).to receive(:deliver_now).and_wrap_original do |_m|
          ActionMailer::Base.deliveries << dummy_mail
        end

        # Mailer が呼ばれたら、この完成済みの dummy_mail を返すようにする
        allow(FeedbackMailer).to receive(:send_feedback).and_return(dummy_mail)

        expect {
          post feedbacks_path, params: { message: "内容", question_id: "1" }, as: :turbo_stream
        }.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("送信しました")
      end
    end

    context "異常系" do
      it "メッセージが空なら 422 を返し、送信されないこと" do
        expect {
          post feedbacks_path, params: { message: "", question_id: "1" }, as: :turbo_stream
        }.not_to change { ActionMailer::Base.deliveries.size }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("入力してください")
      end
    end
  end
end
