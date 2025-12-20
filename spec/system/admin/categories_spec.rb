# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin (カテゴリー管理)", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:category) { create(:category, name: "既存カテゴリー", chapter_number: 1, weight: 10.0) }

  before do
    sign_in_as(admin)
    visit admin_root_path
    click_link "カテゴリー一覧"
    expect(page).to have_content "カテゴリー管理"
  end

  it "カテゴリーの一覧が表示されている" do
    expect(page).to have_content "カテゴリー管理"
    expect(page).to have_content "既存カテゴリー"
    expect(page).to have_content "10.0%"
  end

  it "新しいカテゴリーを作成できる" do
    click_link "新規作成"

    fill_in "タイトル", with: "新規カテゴリー"
    fill_in "章番号", with: "2"
    fill_in "出題割合 (%)", with: "20"

    click_button "保存する"

    expect(page).to have_current_path admin_categories_path
    expect(page).to have_content "カテゴリーを作成しました"
    expect(page).to have_content "新規カテゴリー"
  end

  it "一覧画面上でカテゴリーを編集（インライン編集）できる" do
    target_row = "#category_#{category.id}"

    within target_row do
      find("a[aria-label='#{category.name}を編集']").click
      find("input[aria-label='タイトル']").set("編集後カテゴリー")
      find("button[aria-label='変更を保存']").click
    end

    within target_row do
      expect(page).to have_content "編集後カテゴリー"
      expect(page).not_to have_selector "input[name='category[name]']"
    end
  end

  it "カテゴリーを削除できる" do
    target_row = "#category_#{category.id}"

    page.accept_confirm do
      within target_row do
        find("a[aria-label='#{category.name}を削除']").click
      end
    end

    expect(page).to have_content "カテゴリー「既存カテゴリー」を削除しました"
    expect(page).not_to have_selector target_row
  end
end
