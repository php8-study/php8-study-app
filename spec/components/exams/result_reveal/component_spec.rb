# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::ResultReveal::Component, type: :component do
  # テストデータ (80点で合格)
  let(:exam) { create(:exam, :with_score, question_count: 10, correct_count: 8) }

  context "アニメーションが有効な場合" do
    before do
      render_inline(described_class.new(exam: exam, animation: true)) { "中身のコンテンツ" }
    end

    it "Stimulusコントローラー（result-reveal）が接続されること" do
      expect(page).to have_selector("[data-controller='result-reveal']")
    end

    it "JSに渡すデータ属性（スコア・合否）が正しくセットされていること" do
      expect(page).to have_selector("[data-result-reveal-score-value='80.0']")
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
      expect(page).to have_no_selector("[data-controller='result-reveal']")
    end
  end
end
