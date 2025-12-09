# frozen_string_literal: true

require "rails_helper"

RSpec.describe "管理画面", type: :system do
  let(:admin) { create(:user, :admin) }

  before do
    sign_in_as(admin)
    visit admin_root_path
  end

  describe "一覧" do
    it "管理メニューが表示され、各リンクが配置されていること" do
      expect(page).to have_content "管理画面"
      expect(page).to have_link "問題一覧"
      expect(page).to have_link "カテゴリー一覧"
      expect(page).to have_link "ユーザー画面に戻る"
    end

    it "各リンクが正常に動作すること", :aggregate_failures do
      click_link "問題一覧"
      expect(page).to have_current_path(admin_questions_path)

      visit admin_root_path

      click_link "カテゴリー一覧"
      expect(page).to have_current_path(admin_categories_path)

      visit admin_root_path

      click_link "ユーザー画面に戻る"
      expect(page).to have_current_path(root_path)
    end
  end
end
