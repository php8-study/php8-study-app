# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::HistoryItem::Component, type: :component do
  context "合格の場合" do
    let(:passed_exam) { create(:exam, :passed, created_at: Time.zone.parse("2024-01-15 10:00:00")) }

    before do
      render_inline(described_class.new(exam: passed_exam))
    end

    it "合格用の緑色のスタイルが適用されること" do
      expect(page).to have_css(".border-l-emerald-500")
      expect(page).to have_css(".text-emerald-700")
      expect(page).to have_css(".bg-emerald-100\\/50")
    end

    it "PASSEDスタンプが表示されること" do
      expect(page).to have_content("PASSED")
    end

    it "日付がフォーマット通り表示されること" do
      expect(page).to have_content("Jan")
      expect(page).to have_content("15")
    end

    it "詳細ページへのリンクが生成されていること" do
      expect(page).to have_link(href: "/exams/#{passed_exam.id}")
    end

    it "スコアと正解数が正しく表示されること" do
      expect(page).to have_content("#{passed_exam.score_percentage}%")
      expect(page).to have_content(passed_exam.correct_count.to_s)
      expect(page).to have_content("/")
      expect(page).to have_content(passed_exam.total_questions.to_s)
    end
  end

  context "不合格の場合" do
    let(:failed_exam) { create(:exam, :failed) }

    before do
      render_inline(described_class.new(exam: failed_exam))
    end

    it "不合格用の赤色のスタイルが適用されること" do
      expect(page).to have_css(".border-l-red-500")
      expect(page).to have_css(".text-red-700")
    end

    it "FAILEDスタンプが表示されること" do
      expect(page).to have_content("FAILED")
    end
  end
end
