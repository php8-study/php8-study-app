# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exam::Reviews", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:completed_exam) { create(:exam, :completed, :with_questions, user: user) }
  let!(:active_exam) { create(:exam, :with_questions, user: user) }

  before { sign_in_as(user) }
  describe "GET /exams/:id/review" do
    context "正常系" do
      it "確認画面が表示される" do
        get exam_review_path(active_exam)
        expect(response).to have_http_status(:ok)
      end
    end

    context "異常系" do
      let(:other_exam) { create(:exam, user: other_user) }

      it "他人の試験の確認画面にはアクセスできず404になる" do
        get exam_review_path(other_exam)
        expect(response).to have_http_status(:not_found)
      end

      it "終了した試験の確認画面にはアクセスできず404になる" do
        get exam_review_path(completed_exam)
        expect(response).to have_http_status(:not_found)
      end

      it "存在しない試験IDにアクセスすると404になる" do
        get exam_review_path(exam_id: 0)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "LPへリダイレクトされる" do
        get exam_review_path(completed_exam)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
