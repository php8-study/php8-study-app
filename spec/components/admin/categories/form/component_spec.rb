# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Categories::Form::Component, type: :component do
  context "新規作成の場合" do
    let(:category) { Category.new }

    before do
      render_inline(described_class.new(category: category))
    end

    it "空の入力フォームが表示されること" do
      expect(page).to have_selector("form[action='#{admin_categories_path}'][method='post']")

      expect(page.find_field("タイトル").value).to be_blank
      expect(page.find_field("出題割合 (%)").value).to be_blank


      expect(page).to have_button("保存する")
      expect(page).to have_link("キャンセル", href: admin_categories_path)
    end
  end

  context "編集の場合" do
    let(:category) { create(:category, name: "既存カテゴリ", chapter_number: 5, weight: 10.5) }

    before do
      render_inline(described_class.new(category: category))
    end

    it "既存の値が入力されたフォームが表示されること" do
      expect(page).to have_selector("form[action='#{admin_category_path(category)}']")

      expect(page).to have_field("タイトル", with: "既存カテゴリ")
      expect(page).to have_field("章番号", with: "5")
      expect(page).to have_field("出題割合 (%)", with: "10.5")
    end
  end
end
