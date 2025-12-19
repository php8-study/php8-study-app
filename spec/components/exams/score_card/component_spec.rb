# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::ScoreCard::Component, type: :component do
  context "合格の場合" do
    let(:passed_exam) { create(:exam, :passed) }

    before do
      render_inline(described_class.new(exam: passed_exam))
    end

    it "「PASSED」と表示され、緑色のスタイルが適用されること" do
      expect(page).to have_content("PASSED")
      expect(page).to have_selector(".text-emerald-500")
      expect(page).to have_no_selector(".text-red-500")
    end

    it "合格メッセージが表示されること" do
      expect(page).to have_content("おめでとうございます")
    end
  end

  context "不合格の場合" do
    let(:failed_exam) { create(:exam, :failed) }

    before do
      render_inline(described_class.new(exam: failed_exam))
    end

    it "「FAILED」と表示され、赤色のスタイルが適用されること" do
      expect(page).to have_content("FAILED")
      expect(page).to have_selector(".text-red-500")
      expect(page).to have_no_selector(".text-emerald-500")
    end

    it "不合格メッセージが表示されること" do
      expect(page).to have_content("残念ながら不合格です")
    end
  end

  context "表示内容の詳細検証" do
    let(:exam) { create(:exam, :with_score, question_count: 10, correct_count: 8) }

    before do
      render_inline(described_class.new(exam: exam))
    end

    it "正解数と問題総数が正しく表示されること" do
      expect(page).to have_content("8/10")
    end

    it "スコアのパーセンテージが表示されること" do
      expect(page).to have_selector("[data-result-reveal-target='scoreText']", text: "80")
    end

    it "円グラフのスタイル（stroke-dashoffset）が正しく計算されていること" do
      circle = page.find("[data-result-reveal-target='bar']")
      style = circle[:style]

      actual_offset = style[/stroke-dashoffset:\s*([\d.]+)/, 1].to_f

      circumference = described_class::CIRCUMFERENCE
      expected_offset = circumference - (80.0 / 100.0 * circumference)

      expect(actual_offset).to be_within(0.1).of(expected_offset)
    end
  end

  context "境界値の検証" do
    context "10問中10問正解（100%）の場合" do
      let(:exam) { create(:exam, :with_score, question_count: 10, correct_count: 10) }

      before { render_inline(described_class.new(exam: exam)) }

      it "円グラフが完全に塗りつぶされること（オフセットが0に近いこと）" do
        circle = page.find("[data-result-reveal-target='bar']")
        actual_offset = circle[:style][/stroke-dashoffset:\s*([\d.]+)/, 1].to_f

        expect(actual_offset).to be_within(0.1).of(0)
      end
    end

    context "10問中0問正解（0%）の場合" do
      let(:exam) { create(:exam, :with_score, question_count: 10, correct_count: 0) }

      before { render_inline(described_class.new(exam: exam)) }

      it "円グラフが完全に空であること（オフセットが円周と同じであること）" do
        circle = page.find("[data-result-reveal-target='bar']")
        actual_offset = circle[:style][/stroke-dashoffset:\s*([\d.]+)/, 1].to_f

        expect(actual_offset).to be_within(0.1).of(described_class::CIRCUMFERENCE)
      end
    end
  end

  context "データが存在しない場合" do
    it "レンダリングされないこと" do
      render_inline(described_class.new(exam: nil))
      expect(page.text).to be_empty
    end
  end

  context "アニメーションが有効な場合" do
    let(:passed_exam) { create(:exam, :passed) }

    before do
      render_inline(described_class.new(exam: passed_exam, animation: true))
    end

    it "初期状態ではスコアが0表示であること" do
      expect(page).to have_selector("[data-result-reveal-target='scoreText']", text: "0")
    end

    it "初期状態では透明かつ位置がずれていること" do
      wrapper = page.find("[data-result-reveal-target='summary']")

      expect(wrapper[:class]).to include("opacity-0")
      expect(wrapper[:class]).to include("translate-y-4")
    end

    it "円グラフが初期状態（空）になっていること" do
      circle = page.find("[data-result-reveal-target='bar']")
      actual_offset = circle[:style][/stroke-dashoffset:\s*([\d.]+)/, 1].to_f

      expect(actual_offset).to be_within(0.1).of(described_class::CIRCUMFERENCE)
    end
  end
end
