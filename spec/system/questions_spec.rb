# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Questions (ランダム出題)", type: :system do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_choices) }

  describe "学習サイクル" do
    before do
      sign_in_as(user)
      visit root_path
    end

    it "出題を開始し、正解すると『正解』と表示され、次の問題へ遷移できる" do
      click_link "ランダム問題を解く"
      expect(page).to have_content "ランダム出題"

      correct_choice = question.question_choices.find_by(correct: true)
      find("fieldset label", text: correct_choice.content).click
      click_button "解答する"

      expect(page).to have_content "選択肢の正誤"
      expect(page).to have_content "正解"

      click_link "次の問題へ"

      expect(page).to have_content "ランダム出題"
      expect(page).to have_button "解答する"
    end

    it "不正解の場合は『不正解』と表示される" do
      click_link "ランダム問題を解く"

      wrong_choice = question.question_choices.find_by(correct: false)
      find("fieldset label", text: wrong_choice.content).click
      click_button "解答する"

      expect(page).to have_content "選択肢の正誤"
      expect(page).to have_content "不正解"
    end
  end

  describe "未ログイン時の挙動（SEO/CV導線）" do
    it "問題ページ: 回答フォームの代わりに、ログインへの誘導が表示される" do
      visit question_path(question)

      expect(page).to have_content "RandomQuestion.php"

      expect(page).not_to have_button "解答する"
      expect(page).to have_link "ログインして学習をはじめる"
    end

    it "解説ページ: 直接アクセスしてもエラーにならず、ログイン誘導が表示される" do
      visit solution_question_path(question)

      expect(page).to have_content "選択肢の正誤"

      expect(page).not_to have_content "正解"
      expect(page).not_to have_content "不正解"

      expect(page).to have_link "ログインして学習をはじめる"
    end
  end
end
