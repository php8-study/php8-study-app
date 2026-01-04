# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Questions (ランダム出題)", type: :system do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_choices) }

  describe "学習サイクル" do
    before do
      sign_in_as(user)
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

  describe "未ログイン時の挙動（お試し5問制限）" do
    let!(:questions) { create_list(:question, 10, :with_choices) }

    it "ランダムに出題されるが、異なる問題を5問解いた時点で制限がかかる" do
      visit root_path
      click_link "登録せずに5問だけ試してみる"

      viewed_ids = Set.new

      # 無限ループ防止のリミッター (通常は5〜10回程度で抜けるはず)
      20.times do
        break if page.has_current_path?(root_path)

        expect(page).to have_content("ランダム出題")

        viewed_ids << page.current_path.scan(/\d+/).last.to_i

        find("fieldset label", match: :first).click
        click_button "解答する"
        click_link "次の問題へ"
      end

      expect(page).to have_content "お試し版は5問までです"
      expect(viewed_ids.size).to eq 5
    end
  end
end
