# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin (問題管理)", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:category) { create(:category, name: "テストカテゴリー") }
  let!(:question) { create(:question, content: "既存の問題文", category: category) }

  before do
    sign_in_as(admin)
    visit admin_questions_path
  end

  it "登録されている問題が一覧表示されている" do
    expect(page).to have_content "問題管理"

    target_row = "#question_#{question.id}"
    within target_row do
      expect(page).to have_content "既存の問題文"
      expect(page).to have_content "テストカテゴリー"
    end
  end

  it "新しい問題を作成できる" do
    click_link "新規作成"

    fill_in "問題文", with: "新しい問題の本文です"
    fill_in "解説", with: "これは解説文です"
    select "テストカテゴリー", from: "カテゴリー"
    fill_in "公式テキスト参照", with: "100"

    choice_inputs = all("input[aria-label='選択肢の内容']")
    correct_checks = all("input[aria-label='この選択肢を正解にする']")

    choice_inputs[0].set("選択肢A")
    correct_checks[0].check

    choice_inputs[1].set("選択肢B")

    choice_inputs[2].set("選択肢C")

    choice_inputs[3].set("選択肢D")

    click_button "保存する"

    expect(choice_inputs.size).to be >= 4
    expect(page).to have_current_path admin_questions_path
    expect(page).to have_content "問題を作成しました"
    expect(page).to have_content "新しい問題の本文です"
  end

  it "既存の問題を編集できる" do
    question_row = find("tr", text: "##{question.id}")

    within question_row do
      click_on "ID:#{question.id}を編集"
    end

    expect(page).to have_content "問題文"

    fill_in "問題文", with: "編集後の問題文"
    select "テストカテゴリー", from: "カテゴリー"

    click_button "保存" 

    expect(page).to have_content "問題を保存しました"
    expect(page).to have_field "問題文", with: "編集後の問題文"
  end

  it "問題を削除できる" do
    question_row = find("tr", text: "##{question.id}")

    page.accept_confirm do
      within question_row do
        click_on "ID:#{question.id}を削除"
      end
    end

    expect(page).to have_content "問題を削除しました"
    expect(page).to have_no_content "##{question.id}"
  end
end
