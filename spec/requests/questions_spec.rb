# frozen_string_literal: true

# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "Questions", type: :request do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_choices) }

  describe "GET /questions/random" do
    context "ログインしている場合" do
      before { sign_in_as(user) }

      context "利用可能な問題が存在する場合" do
        it "ランダムに選ばれた問題詳細ページへリダイレクトする" do
          get random_questions_path
          expect(response).to redirect_to(%r{/questions/\d+})
        end
      end

      context "利用可能な問題が1つもない場合" do
        before do
          Question.update_all(deleted_at: Time.current)
        end

        it "ルートパスへリダイレクトされ、アラートが表示される" do
          get random_questions_path

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq "現在利用可能な問題がありません"
        end
      end
    end

    context "未ログインの場合" do
      it "ルートパスへリダイレクトされる" do
        get random_questions_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

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
