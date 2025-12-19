# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::QuestionList::Component, type: :component do
  context "問題がある場合" do
    let(:questions) { create_list(:question, 3, content: "テスト問題") }
    let(:exam) { create(:exam, :with_questions, questions: questions) }

    before do
      render_inline(described_class.new(questions: exam.exam_questions))
    end

    it "渡された問題の数だけアイテムが描画されること" do
      expect(page).to have_content("Q.1")
      expect(page).to have_content("Q.3")

      expect(page).to have_text("テスト問題", count: 3)
    end
  end

  context "問題がない場合" do
    it "エラーにならないこと" do
      render_inline(described_class.new(questions: []))

      expect(page).to have_selector("div")
    end
  end
end
