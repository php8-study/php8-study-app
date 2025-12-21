# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Button::Component, type: :component do
  context "リンクとして利用する場合 (hrefあり)" do
    it "aタグがレンダリングされること" do
      render_inline(described_class.new(href: "/exams")) { "履歴一覧" }

      expect(page).to have_link("履歴一覧", href: "/exams")
      expect(page).to have_css("a.bg-indigo-600") # デフォルトはprimary
    end
  end

  context "ボタンとして利用する場合 (hrefなし)" do
    it "buttonタグがレンダリングされること" do
      render_inline(described_class.new(type: :submit)) { "保存" }

      expect(page).to have_button("保存")
      expect(page).to have_css("button[type='submit']")
      expect(page).to have_css("button.bg-indigo-600")
    end
  end

  context "バリエーション" do
    it "primaryスタイルが適用されること" do
      render_inline(described_class.new(variant: :primary)) { "確認" }
      expect(page).to have_css(".bg-indigo-600")
    end

    it "secondaryスタイルが適用されること" do
      render_inline(described_class.new(variant: :secondary)) { "キャンセル" }
      expect(page).to have_css(".bg-white.text-slate-600.border-slate-200")
    end

    it "ghostスタイルが適用されること" do
      render_inline(described_class.new(variant: :ghost)) { "閉じる" }
      expect(page).to have_css(".bg-transparent.text-slate-600")
    end

    it "存在しないバリアントが指定された場合はデフォルト(primary)になること" do
      render_inline(described_class.new(variant: :undefined_variant)) { "テスト" }
      expect(page).to have_css(".bg-indigo-600")
    end
  end

  context "サイズ" do
    it "smサイズが適用されること" do
      render_inline(described_class.new(size: :sm)) { "ボタン" }
      expect(page).to have_css(".px-3.py-1\\.5.text-sm") # .py-1.5 はエスケープが必要
    end

    it "mdサイズが適用されること" do
      render_inline(described_class.new(size: :md)) { "ボタン" }
      expect(page).to have_css(".px-4.py-2.text-base")
    end

    it "lgサイズが適用されること" do
      render_inline(described_class.new(size: :lg)) { "ボタン" }
      expect(page).to have_css(".px-6.py-3.text-lg")
    end

    it "xlサイズが適用されること" do
      render_inline(described_class.new(size: :xl)) { "ボタン" }
      expect(page).to have_css(".px-8.py-4.text-lg")
    end
  end

  context "カスタムクラスのマージ" do
    it "system_argumentsで渡したクラスが適用されること" do
      render_inline(described_class.new(class: "w-full custom-class")) { "カスタム" }
      expect(page).to have_css(".w-full.custom-class")
    end
  end
end
