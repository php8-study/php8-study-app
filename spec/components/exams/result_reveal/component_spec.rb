# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::ResultReveal::Component, type: :component do
  # テストデータ (80点で合格)
  let(:exam) { create(:exam, :with_score, question_count: 10, correct_count: 8) }

  context "アニメーションが有効な場合" do
    before do
      render_inline(described_class.new(exam: exam, animation: true)) { "中身のコンテンツ" }
    end

    it "Stimulusコントローラー（result-reveal と confetti）が接続されること" do
      element = page.find("#reveal-wrapper")
      expect(element["data-controller"]).to include("result-reveal")
      expect(element["data-controller"]).to include("confetti")
    end

    it "JSに渡すデータ属性（合否）が正しくセットされていること" do
      expect(page).to have_selector("[data-result-reveal-passed-value='true']")
    end

    it "ブロック内のコンテンツが描画されること" do
      expect(page).to have_content("中身のコンテンツ")
    end
  end

  context "アニメーションが無効な場合" do
    before do
      render_inline(described_class.new(exam: exam, animation: false)) { "中身" }
    end

    it "Stimulusコントローラーが接続されないこと" do
      element = page.find("#reveal-wrapper")
      expect(element["data-controller"]).to be_nil
    end
  end
end
