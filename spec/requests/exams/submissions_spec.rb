# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exams::Submissions", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:completed_exam) { create(:exam, :completed, :with_questions, user: user) }
  let!(:active_exam) { create(:exam, :with_questions, user: user) }

  before do
    sign_in_as(user)
  end

  describe "POST /exams/:id/submissions" do
    context "正常系" do
      it "試験を終了し、結果画面（reveal付き）へリダイレクトする" do
        post exam_submission_path(active_exam)

        active_exam.reload
        p active_exam
        expect(active_exam.completed_at).to be_present
        expect(response).to redirect_to(exam_path(active_exam, reveal: true))
      end
    end

    context "異常系" do
      context "finish! が false を返した場合" do
        before do
          allow_any_instance_of(Exam).to receive(:finish!).and_return(false)
        end

        it "ルートパスへリダイレクトされる" do
          post exam_submission_path(active_exam)
          expect(response).to redirect_to(root_path)
        end
      end

      context "既に完了している試験を提出しようとした場合" do
        it "404 Not Found になる" do
          post exam_submission_path(completed_exam)
          expect(response).to have_http_status(:not_found)
        end
      end

      context "存在しない試験IDで提出しようとした場合" do
        it "404 Not Found になる" do
          post exam_submission_path(0)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "LPへリダイレクトされる" do
        post exam_submission_path(active_exam)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
