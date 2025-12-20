# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin(管理画面ダッシュボード)", type: :system do
  let(:admin) { create(:user, :admin) }

  before do
    sign_in_as(admin)
  end

  it "管理メニューが表示され、各機能への正しいリンクが配置されている" do
    click_link "管理画面"
    expect(page).to have_content "管理画面"
    expect(page).to have_content "管理する項目を選択してください"

    expect(page).to have_link "問題一覧", href: admin_questions_path
    expect(page).to have_link "カテゴリー一覧", href: admin_categories_path
    expect(page).to have_link "ユーザー画面に戻る", href: root_path
  end
end
