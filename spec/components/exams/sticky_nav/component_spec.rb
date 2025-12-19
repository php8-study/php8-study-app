# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::StickyNav::Component, type: :component do
  context "コンテンツの描画" do
    before do
      render_inline(described_class.new)
    end

    it "ナビゲーションボタンが表示されること" do
      expect(page).to have_link("トップへ戻る", href: root_path)
      expect(page).to have_link("履歴一覧へ戻る", href: exams_path)
    end
  end

  context "アニメーション設定" do
    it "animation: true の場合、非表示クラスが付与されること" do
      render_inline(described_class.new(animation: true))

      expect(page).to have_css("[data-controller='sticky-nav'].opacity-0.translate-y-full")
    end

    it "animation: falseの場合、非表示クラスが付与されないこと" do
      render_inline(described_class.new(animation: false))

      expect(page).to have_no_css(".opacity-0")
      expect(page).to have_no_css(".translate-y-full")
    end
  end
end
