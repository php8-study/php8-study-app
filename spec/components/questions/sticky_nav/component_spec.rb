# frozen_string_literal: true

require "rails_helper"

RSpec.describe Questions::StickyNav::Component, type: :component do
  context "next_path（次の問題へのパス）が指定されている場合" do
    before do
      render_inline(described_class.new(next_path: "/next/question/path"))
    end

    it "トップへ戻るボタンと次の問題へボタンの両方が表示されること" do
      expect(page).to have_selector("[data-controller='sticky-nav']")

      expect(page).to have_link("トップへ戻る", href: "/")
      expect(page).to have_link("次の問題へ", href: "/next/question/path")
    end
  end

  context "next_path が指定されていない場合" do
    before do
      render_inline(described_class.new(next_path: nil))
    end

    it "トップへ戻るボタンのみが表示されること" do
      expect(page).to have_link("トップへ戻る", href: "/")
      expect(page).not_to have_content("次の問題へ")
    end
  end
end
