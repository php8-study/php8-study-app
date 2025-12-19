# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::StickyNav::Component, type: :component do
  context "コンテンツの描画" do
    before do
      render_inline(described_class.new)
    end

    it "ナビゲーションボタンが表示されること" do
      expect(page).to have_link("トップへ戻る")
      expect(page).to have_link("履歴一覧へ戻る")
    end
  end

  context "アニメーション設定" do
    it "animation: true の場合、非表示クラスが付与されること" do
      render_inline(described_class.new(animation: true))

      wrapper = page.find("[data-controller='sticky-nav']")
      expect(wrapper[:class]).to include("opacity-0")
    end
  end
end
