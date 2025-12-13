# frozen_string_literal: true

require "rails_helper"

RSpec.describe "模擬試験受験履歴一覧", type: :request do
  let(:user) { create(:user) }

  describe "履歴一覧" do
    context "ログイン済みユーザー" do
      before { sign_in_as(user) }

      context "履歴がない場合" do
        it "受験ボタンのみ表示される" do
          get exams_path
          expect(response.body).to include("まだ履歴がありません")
          expect(response.body).to include(check_exams_path)
        end
      end

      context "履歴がある場合" do
        let!(:exam_failed) { create(:exam, :failed, user: user, created_at: 3.days.ago) }
        let!(:exam_passed) { create(:exam, :passed, user: user, created_at: 1.day.ago) }

        it "履歴が降順で表示される" do
          get exams_path
          body = response.body

          expect(body).to include(root_path)
          expect(body).to include(check_exams_path)
          expect(body).to include(exam_path(exam_passed))
          expect(body).to include(exam_path(exam_failed))

          expect(body).to include("100.0")
          expect(body).to include("PASSED")
          expect(body).to include("0.0")
          expect(body).to include("FAILED")
        end
      end
    end

    context "非ログインユーザー" do
      it "トップページにリダイレクトされる" do
        get exams_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
