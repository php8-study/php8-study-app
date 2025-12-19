# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::QuestionList::Item::Component, type: :component do
  let(:exam) { create(:exam) }
  let(:category) { create(:category, name: "PHP基礎") }
  let(:question) { create(:question, category: category, content: "これは短い問題文です。") }
  let(:exam_question) { create(:exam_question, exam: exam, question: question, position: 1) }

  context "正解した場合" do
    before do
      allow(exam_question).to receive(:correct?).and_return(true)
      render_inline(described_class.new(exam_question: exam_question))
    end

    it "緑色の背景（正解スタイル）が適用されること" do
      expect(page).to have_selector(".bg-emerald-100")
      expect(page).to have_no_selector(".bg-red-100")
    end

    it "詳細ページへのリンクが正しく設定されていること" do
      expected_path = "/exams/#{exam.id}/exam_questions/#{exam_question.id}/answer"
      expect(page).to have_link(href: expected_path)
    end
  end

  context "不正解の場合" do
    before do
      allow(exam_question).to receive(:correct?).and_return(false)
      render_inline(described_class.new(exam_question: exam_question))
    end

    it "赤色の背景（不正解スタイル）が適用されること" do
      expect(page).to have_selector(".bg-red-100")
      expect(page).to have_no_selector(".bg-emerald-100")
    end
  end

  context "表示内容の検証" do
    it "カテゴリ名が表示されること" do
      render_inline(described_class.new(exam_question: exam_question))
      expect(page).to have_content("PHP基礎")
    end

    it "問題番号（Q.x）が表示されること" do
      render_inline(described_class.new(exam_question: exam_question))
      expect(page).to have_content("Q.1")
    end

    context "問題文が長い場合" do
      let(:long_text) { "テスト" * 50 }
      let(:long_question) { create(:question, category: category, content: long_text) }
      let(:long_exam_question) { create(:exam_question, exam: exam, question: long_question) }

      it "100文字程度で省略（truncate）されること" do
        render_inline(described_class.new(exam_question: long_exam_question))

        expect(page.text).to include("...")
        expect(page.text).not_to include(long_text)
      end
    end
  end
end
