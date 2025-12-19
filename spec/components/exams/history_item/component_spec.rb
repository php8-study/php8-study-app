# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::HistoryItem::Component, type: :component do
  let(:exam_date) { Time.zone.parse("2024-01-15 10:00:00") }

  context "合格 (Passed) の場合" do
    let(:passed_exam) { create(:exam, :passed, created_at: Time.zone.parse("2024-01-15 10:00:00")) }

    before do
      render_inline(described_class.new(exam: passed_exam))
    end

    it "合格用の緑色のスタイルが適用されること" do
      expect(page).to have_css(".border-l-emerald-500")
      expect(page).to have_css(".text-emerald-700")
      expect(page).to have_css(".bg-emerald-100\\/50") # スラッシュのエスケープに注意
    end

    it "PASSEDスタンプが表示されること" do
      expect(page).to have_content("PASSED")
    end

    it "日付がフォーマット通り表示されること" do
      expect(page).to have_content("Jan")
      expect(page).to have_content("15")
    end
  end

  context "不合格 (Failed) の場合" do
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
