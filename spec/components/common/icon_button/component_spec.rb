# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::IconButton::Component, type: :component do
  context "基本レンダリング" do
    before do
      render_inline(described_class.new(
        href: "/test",
        icon: "edit",
        title: "編集ボタン"
      ))
    end

    it "リンクが正しく生成されること" do
      expect(page).to have_link(href: "/test")
      expect(page).to have_selector("a[title='編集ボタン']")
      expect(page).to have_selector("a[aria-label='編集ボタン']")
    end

    it "アイコンが含まれること" do
      expect(page).to have_selector("svg")
    end

    it "デフォルトのスタイル(primary)が適用されること" do
      expected_style = Common::IconButton::Component::VARIANTS[:primary]
      expect(page.find("a")[:class]).to include(expected_style)
    end
  end

  context "バリアント指定" do
    it "dangerバリアントで定義されたスタイルが適用されること" do
      render_inline(described_class.new(href: "#", icon: "trash", variant: :danger))
      
      expected_style = Common::IconButton::Component::VARIANTS[:danger]
      expect(page.find("a")[:class]).to include(expected_style)
    end
  end

  context "Turbo属性（削除ボタンなど）" do
    it "methodとconfirmがdata属性に変換されること" do
      render_inline(described_class.new(
        href: "/delete",
        icon: "trash",
        method: :delete,
        confirm: "本当に削除しますか？"
      ))

      expect(page).to have_selector("a[data-turbo-method='delete']")
      expect(page).to have_selector("a[data-turbo-confirm='本当に削除しますか？']")
    end
  end

  context "任意のデータ属性" do
    it "渡したdataオプションがHTML属性として展開されること" do
      render_inline(described_class.new(
        href: "#",
        icon: "edit",
        data: { turbo_frame: "modal", foo: "bar" }
      ))

      expect(page).to have_selector("a[data-turbo-frame='modal']")
      expect(page).to have_selector("a[data-foo='bar']")
    end

    it "methodやconfirmと併用しても正しくマージされること" do
      render_inline(described_class.new(
        href: "#",
        icon: "trash",
        method: :delete,
        data: { turbo_frame: "_top" }
      ))

      expect(page).to have_selector("a[data-turbo-method='delete']")
      expect(page).to have_selector("a[data-turbo-frame='_top']")
    end
  end
end
