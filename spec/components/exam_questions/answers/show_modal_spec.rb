# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExamQuestions::Answers::ShowModal::Component, type: :component do
  let(:question) { create(:question, :with_choices, content: "Test Code") }
  let(:exam) { create(:exam) }
  
  context "正解の場合" do
    let(:exam_question) { create(:exam_question, exam: exam, question: question) }
    
    before do
      correct_choice = question.question_choices.find_by(correct: true)
      create(:exam_answer, exam_question: exam_question, question_choice: correct_choice)
      
      render_inline(described_class.new(exam_question: exam_question))
    end

    it "「正解の解説」と表示されること" do
      expect(page).to have_content("正解の解説")
    end

    it "内部コンポーネントがレンダリングされていること" do
      expect(page).to have_content("Test Code")
      expect(page).to have_content("Correct Answer")
    end
  end

  context "不正解の場合" do
    let(:exam_question) { create(:exam_question, exam: exam, question: question) }

    before do
      wrong_choice = question.question_choices.find_by(correct: false)
      create(:exam_answer, exam_question: exam_question, question_choice: wrong_choice)
      
      render_inline(described_class.new(exam_question: exam_question))
    end

    it "「不正解の解説」と表示されること" do
      expect(page).to have_content("不正解の解説")
    end
  end
end
