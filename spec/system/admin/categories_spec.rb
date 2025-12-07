# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Categories", type: :system do
  let(:admin) { create(:user, :admin) }
  # テスト対象のカテゴリー
  let!(:category) { create(:category, name: "テストカテゴリー") }

  before do
    sign_in_as(admin)
    visit admin_categories_path
  end

  describe "カテゴリーの削除" do
    context "紐づく問題がない場合 (削除可能)" do
      it "削除に成功し、一覧から行が消える" do
        expect(page).to have_content "テストカテゴリー"

        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_content "カテゴリー「テストカテゴリー」を削除しました"
        expect(page).to have_no_selector("#category_#{category.id}")
      end
    end

    context "紐づく問題がある場合 (削除不可)" do
      before do
        create(:question, category: category)
      end

      it "削除に失敗し、エラーが表示され、行は画面に残ったままになる" do
        expect(page).to have_content "テストカテゴリー"

        accept_confirm do
          find("a[title='削除']").click
        end

        expect(page).to have_content "削除できません：紐付く問題が存在します"
        expect(page).to have_selector("#category_#{category.id}")
        expect(page).to have_content "テストカテゴリー"
      end
    end
  end
end
