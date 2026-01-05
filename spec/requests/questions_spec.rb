# frozen_string_literal: true

# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "Questions", type: :request do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_choices) }
  let!(:questions) { create_list(:question, 10) }

  describe "GET /questions/:id" do
    context "正常系" do
      context "ログインしている場合" do
        before { sign_in_as(user) }

        it "正常に表示される" do
          get question_path(question)
          expect(response).to have_http_status(:ok)
        end

        it "6問目以降も制限なくアクセスできる" do
          questions.first(6).each do |q|
            get question_path(q)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context "未ログインの場合" do
        it "異なる5つの問題までは閲覧できる" do
          questions.first(5).each do |q|
            get question_path(q)
            expect(response).to have_http_status(:ok)
          end
        end

        it "6問目の新しい問題にアクセスすると、会員登録画面へリダイレクトされる" do
          questions.first(5).each { |q| get question_path(q) }

          target_question = questions[5]
          get question_path(target_question)

          expect(response).to redirect_to root_path
          expect(flash[:alert]).to include "5問まで"
        end

        it "閲覧済みの問題（1〜5問目）への再アクセスは許可される" do
          questions.first(5).each { |q| get question_path(q) }

          visited_question = questions[0]
          get question_path(visited_question)

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "異常系" do
      before { sign_in_as(user) }

      it "論理削除された問題にはアクセスできず404 Not Foundになる" do
        deleted_question = create(:question, deleted_at: Time.current)
        get question_path(deleted_question)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
