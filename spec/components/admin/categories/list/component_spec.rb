# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Categories::List::Component, type: :component do
  let!(:category1) { create(:category, name: "カテゴリ1") }
  let!(:category2) { create(:category, name: "カテゴリ2") }
  let(:categories) { Category.all }

  before do
    render_inline(described_class.new(categories: categories))
  end

  it "ヘッダー項目が表示されること" do
    expect(page).to have_content("章番号")
    expect(page).to have_content("タイトル")
    expect(page).to have_content("出題割合")
    expect(page).to have_content("操作")
  end

  it "カテゴリーの行がレンダリングされること" do
    expect(page).to have_content("カテゴリ1")
    expect(page).to have_content("カテゴリ2")
  end

  it "正しいグリッドクラスが適用されていること" do
    expect(page).to have_selector(".grid-cols-\\[50px_350px_1fr_150px_120px\\]")
  end
end
