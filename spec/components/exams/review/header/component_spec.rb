# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::Review::Header::Component, type: :component do
  context "進捗が 0% の場合" do
    let(:exam) { create(:exam, :with_questions, question_count: 10, answered_count: 0) }

    before do
      render_inline(described_class.new(exam: exam))
    end

    it "プログレスバーの幅が 0% であること" do
      expect(page).to have_css('div[style="width: 0%"]')
      expect(page).to have_selector('[aria-valuenow="0"]')
    end

    it "回答数が 0 / 10 と表示されること" do
      expect(page).to have_content("0 / 10")
    end
  end

  context "進捗が 50% の場合" do
    let(:exam) { create(:exam, :with_questions, question_count: 10, answered_count: 5) }

    before do
      render_inline(described_class.new(exam: exam))
    end

    it "プログレスバーの幅が 50% であること" do
      expect(page).to have_css('div[style="width: 50%"]')
      expect(page).to have_selector('[aria-valuenow="50"]')
    end

    it "回答数が 5 / 10 と表示されること" do
      expect(page).to have_content("5 / 10")
    end
  end

  context "進捗が 100% の場合" do
    let(:exam) { create(:exam, :with_questions, question_count: 10, answered_count: 10) }

    before do
      render_inline(described_class.new(exam: exam))
    end

    it "プログレスバーの幅が 100% であること" do
      expect(page).to have_css('div[style="width: 100%"]')
      expect(page).to have_selector('[aria-valuenow="100"]')
    end

    it "回答数が 10 / 10 と表示されること" do
      expect(page).to have_content("10 / 10")
    end
  end

  context "端数が出る場合 (1 / 3)" do
    let(:exam) { create(:exam, :with_questions, question_count: 3, answered_count: 1) }

    before do
      render_inline(described_class.new(exam: exam))
    end

    it "四捨五入して整数（33%）で表示されること" do
      expect(page).to have_css('div[style="width: 33%"]')
      expect(page).to have_selector('[aria-valuenow="33"]')
    end
  end

  context "問題数が 0 の場合 (異常系)" do
    let(:exam) { create(:exam) }

    it "ゼロ除算エラーにならず 0% と表示されること" do
      render_inline(described_class.new(exam: exam))
      expect(page).to have_content("0 / 0")
      expect(page).to have_css('div[style="width: 0%"]')
    end
  end
end
