# frozen_string_literal: true

# 未ログインユーザーは全てLPにリダイレクト。
# 権限違反・不正操作は一律で 404 を返す。

require "rails_helper"

RSpec.describe "ExamQuestions", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:exam) { create(:exam, :with_questions, user: user) }
  let(:exam_question) { exam.exam_questions.first }
  let(:choices) { exam_question.question.question_choices }

  before { sign_in_as(user) }

  describe "POST /exams/:exam_id/exam_questions/:id/answer" do
    let(:valid_params) {
      {
        question_choice_ids: [choices.first.id]
      }
    }

    context "正常系" do
      it "回答を送信すると、データが保存され次の画面へリダイレクトされる" do
        post answer_exam_exam_question_path(exam, exam_question), params: valid_params

        expect(exam_question.reload.user_choices).to include(choices.first)
        expect(response).to have_http_status(:redirect)
      end

      it "複数の選択肢を同時に送信できる" do
        choice1 = choices.first
        choice2 = choices.second

        post answer_exam_exam_question_path(exam, exam_question),
             params: { question_choice_ids: [choice1.id, choice2.id] }

        exam_question.reload
        expect(exam_question.user_choices).to include(choice1, choice2)
        expect(exam_question.user_choices.count).to eq(2)
      end

      it "既に回答がある状態で別の選択肢を送ると、回答が上書きされ、リダイレクトされる" do
        exam_question.update!(user_choices: [choices.first])

        post answer_exam_exam_question_path(exam, exam_question), params: { question_choice_ids: [choices.second.id] }

        exam_question.reload
        expect(exam_question.user_choices).not_to include(choices.first)
        expect(exam_question.user_choices).to include(choices.second)
      end

      it "同じ選択肢を再送信しても、データが重複したりエラーになったりしない" do
        exam_question.update!(user_choices: [choices.first])

        expect {
          post answer_exam_exam_question_path(exam, exam_question), params: valid_params
        }.not_to change { exam_question.reload.user_choices.count }

        expect(response).to have_http_status(:redirect)
      end
    end

    context "異常系（バリデーション）" do
      it "回答を選択せずに送信した場合、更新されずエラーになる" do
        empty_params = { question_choice_ids: [] }

        expect {
          post answer_exam_exam_question_path(exam, exam_question), params: empty_params
        }.not_to change { exam_question.reload.user_choices.count }

        expect(response).to have_http_status(:not_found)
      end
    end

    context "異常系（データ整合性）" do
      it "存在しない question_choice_id を送ると 404 になる" do
        invalid_params = { question_choice_ids: [0] }

        post answer_exam_exam_question_path(exam, exam_question), params: invalid_params
        expect(response).to have_http_status(:not_found)
      end

      it "他の問題の選択肢を送った場合、保存されず 404 になる" do
        other_choice = create(:question_choice)
        invalid_params = { question_choice_ids: [other_choice.id] }

        expect {
          post answer_exam_exam_question_path(exam, exam_question), params: invalid_params
        }.not_to change { exam_question.reload.user_choices.count }

        expect(response).to have_http_status(:not_found)
      end
    end

    context "異常系（ステータス制御）" do
      let(:completed_exam) { create(:exam, :completed, :with_questions, user: user) }
      let(:completed_question) { completed_exam.exam_questions.first }

      it "提出済みの試験の問題には回答できない" do
        post answer_exam_exam_question_path(completed_exam, completed_question), params: valid_params

        expect(completed_question.reload.user_choices).to be_empty
        expect(response).to have_http_status(:not_found)
      end
    end

    context "セキュリティ（権限）" do
      let(:other_exam) { create(:exam, :with_questions, user: other_user) }
      let(:other_question) { other_exam.exam_questions.first }

      it "他人の問題には回答できない" do
        post answer_exam_exam_question_path(other_exam, other_question), params: valid_params

        expect(other_question.reload.user_choices).to be_empty
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "未ログインで回答しようとするとルートパスへリダイレクトされる" do
        post answer_exam_exam_question_path(exam, exam_question), params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /exams/:exam_id/exam_questions/:id" do
    context "正常系" do
      it "自分の進行中の試験の問題ページにはアクセスできる" do
        get exam_exam_question_path(exam, exam_question)
        expect(response).to have_http_status(:ok)
      end
    end

    context "異常系（ステータス制御）" do
      let(:completed_exam) { create(:exam, :completed, :with_questions, user: user) }
      let(:completed_question) { completed_exam.exam_questions.first }

      it "提出済みの試験の問題ページにはアクセスできない" do
        get exam_exam_question_path(completed_exam, completed_question)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "セキュリティ（権限）" do
      let(:other_exam) { create(:exam, :with_questions, user: other_user) }
      let(:other_question) { other_exam.exam_questions.first }

      it "他人の問題ページにはアクセスできない" do
        get exam_exam_question_path(other_exam, other_question)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      before { sign_out }

      it "未ログインでアクセスするとルートパスへリダイレクトされる" do
        get exam_exam_question_path(exam, exam_question)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /exams/:exam_id/exam_questions/:id/solution" do
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
