# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin (カテゴリー管理)", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:category) { create(:category, name: "既存カテゴリー", chapter_number: 1, weight: 10.0) }

  before do
    sign_in_as(admin)
    visit admin_root_path
    click_link "カテゴリー一覧"
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

    expect(page).to have_content "カテゴリーを作成しました"
    expect(page).to have_content "新規カテゴリー"
  end

it "一覧画面上でカテゴリーを編集（インライン編集）できる" do
    find("[role='listitem']", text: category.name).click_on "#{category.name}を編集"

    find("input[aria-label='タイトル']").set("編集後カテゴリー")

    click_button "保存" 

    updated_row = find("[role='listitem']", text: "編集後カテゴリー")
    within updated_row do
      expect(page).to have_content "編集後カテゴリー"
      expect(page).to have_no_selector "input[aria-label='タイトル']"
    end
  end

  it "カテゴリーを削除できる" do
    category_row = find("[role='listitem']", text: category.name)

    page.accept_confirm do
      within category_row do
        click_on "#{category.name}を削除"
      end
    end

    expect(page).to have_no_content(category.name)
  end
end
