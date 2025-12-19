# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Button::Component, type: :component do
  context "リンクとして利用する場合 (hrefあり)" do
    it "aタグがレンダリングされること" do
      render_inline(described_class.new(href: "/exams")) { "履歴一覧" }

      expect(page).to have_link("履歴一覧", href: "/exams")
      expect(page).to have_css("a.bg-indigo-600") # デフォルト
    end
  end

  context "ボタンとして利用する場合 (hrefなし)" do
    it "buttonタグがレンダリングされること" do
      render_inline(described_class.new(type: :submit)) { "保存" }

      expect(page).to have_button("保存")
      expect(page).to have_css("button[type='submit']")
    end
  end

  context "バリエーション" do
    it "secondaryスタイルが適用されること" do
      render_inline(described_class.new(variant: :secondary)) { "キャンセル" }

      expect(page).to have_css(".bg-white.text-slate-600.border-slate-200")
    end

    it "dangerスタイルが適用されること" do
      render_inline(described_class.new(variant: :danger)) { "削除" }

      expect(page).to have_css(".bg-rose-600")
    end
  end
end
