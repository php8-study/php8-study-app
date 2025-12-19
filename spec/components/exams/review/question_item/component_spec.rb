# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::Review::QuestionItem::Component, type: :component do
  subject do
    render_inline(described_class.new(exam: exam, question: exam_question)) do
      "Q 1"
    end
  end

  context "回答済みの場合" do
    let(:exam) { create(:exam, :with_questions, question_count: 1, answered_count: 1) }
    let(:exam_question) { exam.exam_questions.first }

    before { subject }

    it "未回答用のスタイル（破線）が付与されていないこと" do
      expect(page).not_to have_css("a.border-dashed")
    end

    it "問題詳細ページへのリンクが生成されていること" do
      expect(page).to have_link(
        "Q 1",
        href: exam_exam_question_path(exam, exam_question)
      )
    end
  end

  context "未回答の場合" do
    let(:exam) { create(:exam, :with_questions, question_count: 1, answered_count: 0) }
    let(:exam_question) { exam.exam_questions.first }

    before { subject }

    it "未回答用のスタイル（破線）が付与されていること" do
      expect(page).to have_css("a.border-dashed")
    end

    it "問題詳細ページへのリンクが生成されていること" do
      expect(page).to have_link(
        "Q 1",
        href: exam_exam_question_path(exam, exam_question)
      )
    end
  end
end
