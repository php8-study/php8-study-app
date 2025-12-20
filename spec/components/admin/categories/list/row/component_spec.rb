# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Categories::List::Row::Component, type: :component do
  # dom_idを利用するために必要
  include ActionView::RecordIdentifier

  let(:category) { create(:category, name: "テストカテゴリ", chapter_number: 1, weight: 50.0) }
  let(:grid_cols) { "grid-cols-test" }

  before do
    render_inline(described_class.new(category: category, grid_cols: grid_cols))
  end

  it "カテゴリーの情報が表示されること" do
    expect(page).to have_content("1")
    expect(page).to have_content("テストカテゴリ")
    expect(page).to have_content("50.0%")
  end

  it "プログレスバーのスタイルが正しく適用されること" do
    expect(page).to have_selector('div[style*="width: 50.0%"]')
  end

  it "編集・削除リンクが正しく表示されること" do
    expect(page).to have_link(href: edit_admin_category_path(category))
    expect(page).to have_selector("a[data-turbo-frame='#{dom_id(category)}']")

    expect(page).to have_link(href: admin_category_path(category))
    expect(page).to have_selector("a[data-turbo-method='delete']")
  end

  it "Turbo Frame でラップされていること" do
    expect(page).to have_selector("turbo-frame[id='#{dom_id(category)}']")
  end
end
