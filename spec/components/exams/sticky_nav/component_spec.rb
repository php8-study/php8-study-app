# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::StickyNav::Component, type: :component do
  context "コンテンツの描画" do
    it "ブロックで渡した内容が表示されること" do
      render_inline(described_class.new) do
        "<button>次のアクション</button>".html_safe
      end

      expect(page).to have_button("次のアクション")
    end
  end

  context "アニメーション設定" do
    it "animation: true の場合、初期状態で非表示（透明・位置ズレ）クラスが付与されること" do
      render_inline(described_class.new(animation: true)) { "ボタン" }

      expect(page).to have_selector(".opacity-0")
      expect(page).to have_selector(".translate-y-4")
    end

    it "animation: false の場合、非表示クラスが付与されないこと" do
      render_inline(described_class.new(animation: false)) { "ボタン" }

      expect(page).to have_no_selector(".opacity-0")
      expect(page).to have_no_selector(".translate-y-4")
    end
  end
end
