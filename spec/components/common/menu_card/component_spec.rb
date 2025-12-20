# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::MenuCard::Component, type: :component do
  it "指定した情報でカードが表示されること" do
    render_inline(described_class.new(
      title: "テストタイトル",
      description: "テスト説明文",
      url: "/test_url",
      theme: :blue,
      icon: "beaker"
    ))

    expect(page).to have_link(href: "/test_url")
    expect(page).to have_content("テストタイトル")
    expect(page).to have_content("テスト説明文")

    expect(page).to have_selector(".from-blue-500")
  end
end
