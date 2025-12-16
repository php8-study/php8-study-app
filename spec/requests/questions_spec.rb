# frozen_string_literal: true

# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "Questions", type: :request do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_choices) }

  describe "GET /questions/:id" do
    context "正常系" do
      it "ログインしていれば、正常に表示される" do
        sign_in_as(user)
        get question_path(question)
        expect(response).to have_http_status(:ok)
      end

      it "未ログインでも、SEO用に正常に表示される" do
        get question_path(question)
        expect(response).to have_http_status(:ok)
      end
    end

    context "異常系" do
      before { sign_in_as(user) }

      it "存在しないIDにアクセスすると404 Not Foundになる" do
        get question_path(0)
        expect(response).to have_http_status(:not_found)
      end

      it "論理削除された問題にはアクセスできず404 Not Foundになる" do
        deleted_question = create(:question, deleted_at: Time.current)
        get question_path(deleted_question)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
