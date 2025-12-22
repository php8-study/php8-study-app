# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::IconButton::Component, type: :component do
  context "リンクとして使用する場合" do
    before do
      render_inline(described_class.new(
        href: "/test",
        icon: "edit",
        title: "編集ボタン"
      ))
    end

    it "リンクが生成されること" do
      expect(page).to have_link(href: "/test")
      expect(page).to have_selector("a[title='編集ボタン']")
      expect(page).to have_selector("a[aria-label='編集ボタン']")
    end

    it "アイコンが含まれること" do
      expect(page).to have_selector("a svg")
    end

    it "Turbo用のデータ属性が正しく設定されること" do
      render_inline(described_class.new(
        href: "/delete",
        icon: "trash",
        method: :delete,
        confirm: "削除しますか？"
      ))
      
      expect(page).to have_selector("a[data-turbo-method='delete']")
      expect(page).to have_selector("a[data-turbo-confirm='削除しますか？']")
    end
  end

  context "ボタンとして使用する場合" do
    before do
      render_inline(described_class.new(
        icon: "check",
        type: :submit,
        title: "保存ボタン",
        data: { controller: "test-controller" }
      ))
    end

    it "ボタン(buttonタグ)が生成されること" do
      expect(page).to have_selector("button[type='submit']")
      expect(page).to have_selector("button[title='保存ボタン']")
    end

    it "アイコン(SVG)が含まれること" do
      expect(page).to have_selector("button svg")
    end

    it "任意のデータ属性が設定されること" do
      expect(page).to have_selector("button[data-controller='test-controller']")
    end
  end

  context "スタイルのバリアント" do
    it "primaryバリアントが適用されること" do
      render_inline(described_class.new(href: "#", icon: "edit"))
      
      expected_class = Common::IconButton::Component::VARIANTS[:primary]
      expect(page.find("a")[:class]).to include(expected_class)
    end

    it "dangerバリアントが適用されること" do
      render_inline(described_class.new(href: "#", icon: "trash", variant: :danger))
      
      expected_class = Common::IconButton::Component::VARIANTS[:danger]
      expect(page.find("a")[:class]).to include(expected_class)
    end
  end
end
