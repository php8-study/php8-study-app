# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ExamFlow", type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "基礎知識") }
  let!(:questions) do
    create_list(:question, 5, :with_choices, category: category, content: "テスト問題")
  end

  before do
    sign_in_as(user)
  end

  describe "試験の実施フロー" do
    it "開始 -> 中断 -> 再開 -> スキップ -> 終了 まで、データが正しく処理されること" do
      visit root_path
      click_link "模擬試験を受験する"

      expect(page).to have_current_path(%r{/exams/\d+/exam_questions/\d+})
      expect(page).to have_content "模擬試験"

      answer_current_question(correct: true)
      click_button "回答する"

      visit root_path
      click_link "模擬試験を受験する"
      expect(page).to have_content "未完了の模擬試験があります"
      click_link "続きから再開"
      expect(page).to have_content "回答状況の確認"
      click_link "2"
      expect(page).to have_selector("span.text-xl.font-black.text-indigo-600", text: "2")

      4.times do |i|
        question_number = i + 2
        expect(page).to have_selector("span.text-xl.font-black.text-indigo-600", text: "#{question_number}")

        if question_number == 2
          click_on "後で回答する"
        else
          answer_current_question(correct: true)
          click_button "回答する"
        end
      end

      accept_confirm("本当に提出しますか？提出後は変更できません。") do
        click_button "試験を提出して採点する"
      end

      expect(page).to have_content("80", wait: 10) # アニメーションを待機
    end
  end

  def answer_current_question(correct:)
    current_id = current_path.split("/").last
    target_choices = ExamQuestion.find(current_id).question.question_choices.where(correct: correct)

    target_choices.each do |choice|
      check choice.content
    end
  end
end
