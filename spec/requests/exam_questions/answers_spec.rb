# frozen_string_literal: true

# 未ログインユーザーは全てLPにリダイレクト。
# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "ExamQuestions::Answers", type: :request do
  let(:user) { create(:user) }

  let!(:exam) { create(:exam, :with_questions, user: user) }
  let(:exam_question) { exam.exam_questions.first }

  before { sign_in_as(user) }
  describe "GET /exams/:exam_id/exam_questions/:id/answer" do
    context "正常系" do
      let(:completed_exam) { create(:exam, :completed, :with_questions, user: user) }
      let(:completed_question) { completed_exam.exam_questions.first }

      it "試験完了後であれば、解答をTurbo Streamで取得できる" do
        get exam_exam_question_answer_path(completed_exam, completed_question), as: :turbo_stream

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context "異常系（ステータス制御）" do
      it "試験中（未完了）の場合は解答にアクセスできず 404 になる" do
        get exam_exam_question_answer_path(exam, exam_question), as: :turbo_stream
        expect(response).to have_http_status(:not_found)
      end
    end

    context "セキュリティ（権限）" do
      let(:other_exam) { create(:exam, :completed, :with_questions, user: other_user) }
      let(:other_question) { other_exam.exam_questions.first }
      let(:other_user) { create(:user) }

      it "他人の試験の解答にはアクセスできず 404 になる" do
        get exam_exam_question_answer_path(other_exam, other_question), as: :turbo_stream
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "未ログインでアクセスするとルートパスへリダイレクトされる" do
        get exam_exam_question_answer_path(exam, exam_question), as: :turbo_stream
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
