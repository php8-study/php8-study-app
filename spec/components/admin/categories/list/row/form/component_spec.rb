# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Categories::List::Row::Form::Component, type: :component do
  include ActionView::RecordIdentifier

  let(:category) { create(:category, name: "編集対象", chapter_number: 9, weight: 80.0) }
  let(:grid_cols) { "grid-cols-test" }

  before do
    render_inline(described_class.new(category: category, grid_cols: grid_cols))
  end

  it "編集フォームが Turbo Frame 内にレンダリングされること" do
    expect(page).to have_selector("turbo-frame[id='#{dom_id(category)}']")
    expect(page).to have_selector("form[action='#{admin_category_path(category)}']")
  end

  it "既存の値が入力フィールドにセットされていること" do
    expect(page).to have_selector("input[name='category[name]'][value='編集対象']")
    expect(page).to have_selector("input[name='category[chapter_number]'][value='9']")
    expect(page).to have_selector("input[name='category[weight]'][value='80.0']")
  end

  it "操作ボタンが表示されること" do
    expect(page).to have_selector("button[type='submit']")

    expect(page).to have_link(href: admin_category_path(category))

    expect(page).to have_selector("a[data-turbo-frame='#{dom_id(category)}']")
  end
end
