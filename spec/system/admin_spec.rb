# frozen_string_literal: true

require "rails_helper"

RSpec.describe "管理", type: :system do
  let(:admin) { create(:user, :admin) }

  before do
    sign_in_as(admin)
    visit admin_root_path
  end

  describe "一覧" do
    it "管理メニューが表示され、各リンクが配置されていること" do
      expect(page).to have_content "管理画面"

      expect(page).to have_link "問題一覧", href: admin_questions_path
      expect(page).to have_link "カテゴリー一覧", href: admin_categories_path
      expect(page).to have_link "ユーザー画面に戻る", href: root_path
    end
  end
end
