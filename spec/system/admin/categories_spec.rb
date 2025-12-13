# frozen_string_literal: true

require "rails_helper"

RSpec.describe "管理画面 カテゴリー (UI操作)", type: :system do
  let(:admin) { create(:user, :admin) }
  let!(:category) { create(:category, name: "テストカテゴリー") }

  before do
    sign_in_as(admin)
    visit admin_categories_path
    expect(page).to have_content "カテゴリー管理"
  end

  describe "一覧表示" do
    it "アクションボタンが表示されること" do
      within "#category_#{category.id}" do
        expect(page).to have_selector "a[title='編集']"
        expect(page).to have_selector "a[title='削除']"
      end
    end
  end

  describe "削除操作" do
    context "紐づく問題がない場合" do
      it "行が削除される" do
        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_no_selector("#category_#{category.id}")
      end
    end

    context "紐づく問題がある場合" do
      before { create(:question, category: category) }

      it "削除できず画面に残る" do
        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_selector("#category_#{category.id}")
        expect(page).to have_content "削除できません"
      end
    end
  end
end
