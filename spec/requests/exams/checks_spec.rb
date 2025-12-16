# frozen_string_literal: true

# 未ログインユーザーは全てLPにリダイレクト。
# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "Exams::Checks", type: :request do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe "GET /exams/check" do
    context "正常系" do
      context "進行中の試験がある場合" do
        let!(:active_exam) { create(:exam, :with_questions, user: user) }

        it "再開確認画面（checkテンプレート）が表示される" do
          get check_exams_path
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("未完了の模擬試験があります")
        end
      end

      context "進行中の試験がない場合" do
        before do
          user.exams.destroy_all
        end

        it "自動開始画面（auto_startテンプレート）が表示される" do
          get check_exams_path
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("試験データを作成しています")
        end
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "LPへリダイレクトされる" do
        get check_exams_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
