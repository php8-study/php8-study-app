# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exam(受験動作)", type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "基礎知識") }
  let!(:questions) { create_list(:question, 3, :with_choices, category: category) }

  before { sign_in_as(user) }

  describe "メインシナリオ" do
    it "試験を開始し、回答〜見直し〜提出までの一連の流れを行える" do
      click_link "模擬試験を受験する"
      expect(page).to have_content "ExamQuestion_1"

      choices = all("fieldset label")
      target_element = choices.first
      target_choice_text = target_element.text

      target_element.click
      click_button "回答する"

      expect(page).to have_content "ExamQuestion_2"
      click_link "前へ"

      expect(page).to have_content "ExamQuestion_1"
      expect(page).to have_checked_field(target_choice_text)
      click_link "後で回答する"

      expect(page).to have_content "ExamQuestion_2"
      click_link "後で回答する"

      expect(page).to have_content "ExamQuestion_3"
      click_link "回答せずに確認画面へ"

      expect(page).to have_content "回答状況の確認"
      click_link "3"

      expect(page).to have_content "ExamQuestion_3"
      click_link "回答状況一覧へ"

      expect(page).to have_content "回答状況の確認"

      accept_confirm do
        click_button "試験を提出して採点する"
      end

      expect(page).to have_content "試験結果"
      expect(page).to have_current_path(%r{/exams/\d+}, ignore_query: true)
    end
  end

  describe "中断・再開機能" do
    let!(:old_exam) { create(:exam, user: user) }

    before do
      visit root_path
      click_link "模擬試験を受験する"
    end

    it "中断データがある場合、確認ダイアログを経て再開できる" do
      expect(page).to have_content "未完了の模擬試験があります"

      click_link "続きから再開"

      expect(page).to have_content "回答状況の確認"
      expect(current_path).to include("/exams/#{old_exam.id}/")
    end

    it "確認ダイアログで「破棄」を選択すると、新規に開始できる" do
      accept_confirm do
        click_button "破棄して新規開始"
      end

      expect(page).to have_content "ExamQuestion_1"
      expect(current_path).not_to include("/exams/#{old_exam.id}/")
    end
  end

  describe "バリデーション" do
    let!(:exam) { create(:exam, :with_questions, user: user) }

    it "回答を選択せずにボタンを押すと、アラートが表示され遷移しない" do
      visit exam_exam_question_path(exam, exam.exam_questions.first)

      accept_alert("回答を選択してください。\n後で回答する場合は「後で回答する」ボタンを使用してください。") do
        click_button "回答する"
      end

      expect(current_path).to eq exam_exam_question_path(exam, exam.exam_questions.first)
    end
  end
end
