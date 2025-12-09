# frozen_string_literal: true

require "rails_helper"

RSpec.describe "模擬試験機能", type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "基礎知識") }
  let!(:questions) { create_list(:question, 3, :with_choices, category: category) }

  before do
    sign_in_as(user)
  end

  describe "試験の開始" do
    context "中断データがない場合" do
      it "新規に試験を開始できる" do
        click_link "模擬試験を受験する"

        expect(page).to have_content "模擬試験"
        expect(page).to have_content "ExamQuestion_1"
        expect(Exam.count).to eq 1
      end
    end

    context "中断データがある場合" do
      let!(:old_exam) { create(:exam, user: user) }

      before do
        click_link "模擬試験を受験する"
        expect(page).to have_content "未完了の模擬試験があります"
      end

      it "確認画面が表示され、続きから再開できる" do
        click_link "続きから再開"

        expect(page).to have_content "回答状況の確認"
        expect(current_path).to include("/exams/#{old_exam.id}/")
      end

      it "既存データを破棄して新規開始できる" do
        accept_confirm do
          click_button "破棄して新規開始"
        end

        expect(page).to have_content "ExamQuestion_1"
        expect(current_path).not_to include("/exams/#{old_exam.id}/")
        expect(Exam.count).to eq 1
      end
    end
  end

  context "試験中" do
    let!(:exam) { create(:exam, user: user) }
    let!(:exam_questions) do
      questions.map.with_index(1) do |q, i|
        create(:exam_question, exam: exam, question: q, position: i)
      end
    end
    let(:q1) { exam_questions.first }
    let(:q2) { exam_questions.second }
    let(:last_q) { exam_questions.last }

    describe "回答画面の操作" do
      before do
        visit exam_exam_question_path(exam, q1)
        expect(page).to have_content "模擬試験"
      end

      it "最初の問題には「前へ」ボタンが表示されない" do
        expect(page).to have_no_link "前へ"
      end

      it "「前へ」ボタンが表示され、前の問題に戻れる" do
        visit exam_exam_question_path(exam, q2)
        expect(page).to have_link "前へ"
        click_link "前へ"
        expect(page).to have_current_path(exam_exam_question_path(exam, q1))
      end

      it "選択肢を選んで回答し、次の問題へ遷移できる" do
        target_choice = q1.question.question_choices.first
        check target_choice.content
        click_button "回答する"

        expect(page).to have_current_path(exam_exam_question_path(exam, q2))
        expect(q1.reload.exam_answers).to be_present
      end

      it "回答済みの場合は再回答してデータを更新できる" do
        first_choice = q1.question.question_choices.first
        create(:exam_answer, exam_question: q1, question_choice: q1.question.question_choices.first)
        refresh

        expect(page).to have_button "回答を変更する"
        uncheck first_choice.content

        other_choice = q1.question.question_choices.last
        check other_choice.content

        click_button "回答を変更する"

        expect(page).to have_current_path(exam_exam_question_path(exam, q2))
        expect(q1.reload.exam_answers.count).to eq 1
        expect(q1.exam_answers.first.question_choice).to eq other_choice
      end

      it "「後で回答するボタン」で回答せずに次の問題に進める" do
        click_link "後で回答する"

        expect(page).to have_current_path(exam_exam_question_path(exam, q2))
        expect(q1.reload.exam_answers).to be_empty
      end

      it "選択肢を選ばずに回答ボタンを押すとアラートが表示され、画面遷移しない" do
        accept_alert("回答を選択してください。\n後で回答する場合は「後で回答する」ボタンを使用してください。") do
          click_button "回答する"
        end

        expect(page).to have_current_path(exam_exam_question_path(exam, q1))
      end

      it "回答状況一覧へボタンで確認画面へ遷移できる" do
        click_link "回答状況一覧へ"
        expect(page).to have_current_path(review_exam_path(exam))
      end
    end

    describe "最後の問題" do
      before do
        visit exam_exam_question_path(exam, last_q)
        expect(page).to have_content "模擬試験"
      end

      it "回答すると確認画面へ遷移できる" do
        click_button "回答する"
        expect(page).to have_current_path(review_exam_path(exam))
      end

      it "後で回答するボタンの文言が回答せずに確認画面へに変更される" do
        expect(page).to have_link "回答せずに確認画面へ"
      end
    end

    describe "回答状況一覧画面" do
      before do
        create(:exam_answer, exam_question: q1, question_choice: q1.question.question_choices.first)
        visit review_exam_path(exam)
        expect(page).to have_content "回答状況の確認"
      end

      it "回答済み・未回答のステータスが識別でき、各問題へ移動できる" do
        link_q1 = find("a[href*='/exam_questions/#{q1.id}']")
        link_q2 = find("a[href*='/exam_questions/#{q2.id}']")

        expect(link_q1[:class]).not_to eq link_q2[:class]

        click_link "2"
        expect(page).to have_content "ExamQuestion_2"
        expect(page).to have_current_path(exam_exam_question_path(exam, q2))
      end

      it "試験を提出して採点できる" do
        accept_confirm do
          click_button "試験を提出して採点する"
        end

        expect(page).to have_content "試験結果"
        expect(page).to have_current_path(exam_path(exam), ignore_query: true)
      end
    end
  end
end
