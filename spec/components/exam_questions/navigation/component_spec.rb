# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExamQuestions::Navigation::Component, type: :component do
  let(:exam) { create(:exam, :with_questions) }

  let(:question1) { exam.exam_questions.find_by(position: 1) }
  let(:question2) { exam.exam_questions.find_by(position: 2) }
  let(:question3) { exam.exam_questions.find_by(position: 3) }

  context "最初の問題の場合 (position: 1)" do
    before do
      render_inline(described_class.new(exam: exam, exam_question: question1))
    end

    it "「前へ」ボタンが表示されないこと" do
      expect(page).not_to have_link("前へ")
    end

    it "「回答状況一覧へ」ボタンが表示されること" do
      expect(page).to have_link("回答状況一覧へ", href: "/exams/#{exam.id}/review")
    end

    it "「後で回答する」ボタンが表示されること" do
      expect(page).to have_link("後で回答する", href: "/exams/#{exam.id}/exam_questions/#{question2.id}")
    end
  end

  context "中間の問題の場合 (position: 2)" do
    before do
      render_inline(described_class.new(exam: exam, exam_question: question2))
    end

    it "「前へ」ボタンが表示されること" do
      expect(page).to have_link("前へ", href: "/exams/#{exam.id}/exam_questions/#{question1.id}")
    end

    it "「後で回答する」ボタンが表示されること" do
      expect(page).to have_link("後で回答する", href: "/exams/#{exam.id}/exam_questions/#{question3.id}")
    end
  end

  context "最後の問題の場合 (position: 3)" do
    before do
      render_inline(described_class.new(exam: exam, exam_question: question3))
    end

    it "「前へ」ボタンが表示されること" do
      expect(page).to have_link("前へ")
    end

    it "「回答せずに確認画面へ」ボタンが表示され、「後で回答する」は表示されないこと" do
      expect(page).not_to have_link("後で回答する")

      expect(page).to have_link("回答せずに確認画面へ", href: "/exams/#{exam.id}/review")
    end
  end
end
