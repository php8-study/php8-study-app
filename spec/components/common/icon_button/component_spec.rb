# spec/components/common/icon_button/component_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::IconButton::Component, type: :component do
  context "リンク(hrefあり)として使用する場合" do
    before do
      render_inline(described_class.new(
        href: "/test",
        icon: "edit",
        title: "編集ボタン"
      ))
    end

    it "aタグが生成され、適切な属性が付与されること" do
      expect(page).to have_link(href: "/test")
      expect(page).to have_css("a[title='編集ボタン']")
      expect(page).to have_css("a[aria-label='編集ボタン']")
    end

    it "アイコン(SVG)が含まれること" do
      expect(page).to have_css("a svg")
    end

    context "Turbo関連の属性(method/confirm)を指定した場合" do
      before do
        render_inline(described_class.new(
          href: "/delete",
          icon: "trash",
          method: :delete,
          confirm: "本当に削除しますか？"
        ))
      end

      it "Turbo用のデータ属性が正しく設定されること" do
        expect(page).to have_css("a[data-turbo-method='delete']")
        expect(page).to have_css("a[data-turbo-confirm='本当に削除しますか？']")
      end
    end
  end

  context "ボタン(hrefなし)として使用する場合" do
    before do
      render_inline(described_class.new(
        icon: "check",
        type: :submit,
        title: "保存ボタン",
        data: { controller: "test-controller" }
      ))
    end

    it "buttonタグが生成され、適切な属性が付与されること" do
      expect(page).to have_css("button[type='submit']")
      expect(page).to have_css("button[title='保存ボタン']")
      expect(page).to have_css("button[aria-label='保存ボタン']")
    end

    it "アイコン(SVG)が含まれること" do
      expect(page).to have_css("button svg")
    end

    it "任意のデータ属性(Stimulusなど)が設定されること" do
      expect(page).to have_css("button[data-controller='test-controller']")
    end
  end

  context "スタイルのバリアント" do
    it "primaryバリアントが適用されること" do
      render_inline(described_class.new(icon: "edit"))

      expected_class = Common::IconButton::Component::VARIANTS[:primary]
      expect(page.find("button")[:class]).to include(expected_class)
    end

    it "secondaryバリアントが適用されること" do
      render_inline(described_class.new(icon: "x", variant: :secondary))

      expected_class = Common::IconButton::Component::VARIANTS[:secondary]
      expect(page.find("button")[:class]).to include(expected_class)
    end

    it "dangerバリアントが適用されること" do
      render_inline(described_class.new(icon: "trash", variant: :danger))

      expected_class = Common::IconButton::Component::VARIANTS[:danger]
      expect(page.find("button")[:class]).to include(expected_class)
    end
  end
end
