# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exams", type: :request do
  let(:user) { create(:user) }
  let!(:exam) { create(:exam, :with_questions, question_count: 3, user: user) }
  let(:q1) { exam.exam_questions.first }
  let(:q2) { exam.exam_questions.second }

  describe "未ログイン時のアクセス制限" do
    context "試験一覧ページへのアクセス" do
      it "ルートパス（またはログイン画面）へリダイレクトされる" do
        get exams_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "試験詳細ページへのアクセス" do
      it "リダイレクトされる" do
        get exam_path(exam)
        expect(response).to redirect_to(root_path)
      end
    end

    context "データ作成（POST）の試行" do
      it "作成されず、リダイレクトされる" do
        expect {
          post exams_path
        }.not_to change(Exam, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "他人のデータに対する操作" do
    let(:other_user) { create(:user) }
    let(:other_exam) { create(:exam, :with_questions, user: other_user) }
    let(:other_q1) { other_exam.exam_questions.first }
    let(:other_answer) { create(:exam_answer, exam_question: other_q1) }

    before { sign_in_as(user) }

    shared_examples "アクセス権がなく404が返る" do
      it "404 Not Found を返す" do
        subject
        expect(response).to have_http_status(404)
      end
    end

    context "閲覧 (GET)" do
      context "他人の試験ページ" do
        subject { get exam_path(other_exam) }
        it_behaves_like "アクセス権がなく404が返る"
      end

      context "他人の試験問題画面" do
        subject { get exam_exam_question_path(other_exam, other_q1) }
        it_behaves_like "アクセス権がなく404が返る"
      end

      context "他人のレビュー画面" do
        subject { get review_exam_path(other_exam) }
        it_behaves_like "アクセス権がなく404が返る"
      end
    end

    context "書き込み" do
      let(:choice) { other_q1.question.question_choices.first }
      context "他人の試験に回答を作成しようとした場合" do
        subject {
          post answer_exam_exam_question_path(other_exam, other_q1), params: {
            question_choice_ids: [choice.id]
          }
        }
        it_behaves_like "アクセス権がなく404が返る"
      end

      context "他人の回答を更新しようとした場合" do
        subject {
          patch answer_exam_exam_question_path(other_exam, other_q1, other_answer), params: {
            question_choice_ids: [choice.id]
          }
        }
        it_behaves_like "アクセス権がなく404が返る"
      end

      context "他人の試験を提出しようとした場合" do
        subject { post submissions_exam_path(other_exam) }
        it_behaves_like "アクセス権がなく404が返る"
      end
    end
  end

  describe "完了済み試験に対する操作" do
    let(:completed_exam) { create(:exam, :completed, :with_questions, user: user) }
    let(:completed_q1) { completed_exam.exam_questions.first }

    before { sign_in_as(user) }

    context "閲覧 (GET)" do
      it "回答画面にはアクセスできない（404 Not Found）" do
        get exam_exam_question_path(completed_exam, completed_q1)
        expect(response).to have_http_status(404)
      end
    end

    context "書き込み (POST/PATCH)" do
      let(:choice) { completed_q1.question.question_choices.first }

      it "完了後に回答を作成しようとしても保存されない" do
        expect {
          post answer_exam_exam_question_path(completed_exam, completed_q1), params: {
            exam_answer: { question_choice_id: choice.id }
          }
        }.not_to change(ExamAnswer, :count)

        expect(response).to have_http_status(404)
      end

      it "完了後に回答を更新しようとしても変更されない" do
        existing_answer = create(:exam_answer, exam_question: completed_q1, question_choice: choice)
        completed_q1.question.question_choices.last

        patch answer_exam_exam_question_path(completed_exam, completed_q1, existing_answer), params: {
          question_choice_ids: [choice.id]
        }

        expect(existing_answer.reload.question_choice).to eq choice
      end
    end
  end

  describe "正常な試験進行" do
    before { sign_in_as(user) }

    describe "試験の作成 (POST /exams)" do
      let(:new_user) { create(:user) }
      let!(:questions) { create_list(:question, 5, :with_choices) }

      before { sign_in_as(new_user) }

      it "試験が新規作成され、1問目にリダイレクトされる" do
        expect { post exams_path }.to change(Exam, :count).by(1)
        new_exam = Exam.last
        expect(response).to redirect_to(exam_exam_question_path(new_exam, new_exam.exam_questions.first))
      end
    end

    describe "回答の送信 (POST)" do
      let(:choice) { q1.question.question_choices.first }
      it "選んだ回答が保存され、次の問題へリダイレクトされる" do
        expect {
          post answer_exam_exam_question_path(exam, q1), params: {
            question_choice_ids: [choice.id]
          }
        }.to change(ExamAnswer, :count).by(1)

        expect(q1.exam_answers.last.question_choice).to eq choice
        expect(response).to redirect_to(exam_exam_question_path(exam, q2))
      end
    end

    describe "回答の更新 (PATCH)" do
      let(:choice) { q1.question.question_choices.first }
      let!(:answer) { create(:exam_answer, exam_question: q1, question_choice: choice) }
      let(:new_choice) { q1.question.question_choices.last }

      it "回答データが更新され、次の問題へリダイレクトされる" do
        expect {
          post answer_exam_exam_question_path(exam, q1), params: {
             question_choice_ids: [new_choice.id]
          }
        }.not_to change(ExamAnswer, :count)

        expect(q1.exam_answers.last.question_choice).to eq new_choice
        expect(response).to redirect_to(exam_exam_question_path(exam, q2))
      end
    end

    describe "試験の提出と採点 (POST submit)" do
      it "提出するとステータスが完了になり、結果画面へ遷移する" do
        post submissions_exam_path(exam)
        exam.reload
        expect(exam.completed_at).to be_present
        expect(response).to redirect_to(exam_path(exam, reveal: true))
      end
    end
  end

  describe "画面表示の制御" do
    before { sign_in_as(user) }

    context "1問目の表示" do
      it "「前へ」ボタンが存在しない" do
        get exam_exam_question_path(exam, q1)
        expect(response.body).not_to include("前へ")
      end
    end

    context "2問目の表示" do
      it "「前へ」ボタンが存在する" do
        get exam_exam_question_path(exam, q2)
        expect(response.body).to include(exam_exam_question_path(exam, q1))
      end
    end

    context "最後の問題の表示" do
      it "「後で回答する」ボタンの文言が変わっている" do
        get exam_exam_question_path(exam, exam.exam_questions.last)
        expect(response.body).to include("回答せずに確認画面へ")
      end
    end

    context "回答一覧画面" do
      it "正常に表示される" do
        get review_exam_path(exam)
        expect(response).to have_http_status(200)
        expect(response.body).to include("回答状況の確認")
      end
    end
  end
end
