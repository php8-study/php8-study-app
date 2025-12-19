# frozen_string_literal: true

require "rails_helper"

RSpec.describe Questions::ChoicesFeedback::Component, type: :component do
  let(:question) { create(:question) }
  let!(:correct_choice) { create(:question_choice, question: question, correct: true, content: "正解の選択肢") }
  let!(:wrong_choice) { create(:question_choice, question: question, correct: false, content: "不正解の選択肢") }

  context "ユーザーが正解を選んだ場合" do
    before do
      render_inline(described_class.new(question: question, user_choice_ids: [correct_choice.id]))
    end

    it "正解の選択肢に「YOUR CHOICE」と「CORRECT ANSWER」が表示されること" do
      target_row = page.find("li", text: /CORRECT ANSWER/i)

      expect(target_row).to have_content(/YOUR CHOICE/i)
    end
  end

  context "ユーザーが不正解を選んだ場合" do
    before do
      render_inline(described_class.new(question: question, user_choice_ids: [wrong_choice.id]))
    end

    it "選んだ不正解の選択肢に「YOUR CHOICE」が表示され、赤枠になること" do
      target_row = page.find("li", text: /YOUR CHOICE/i)

      expect(target_row).not_to have_content(/CORRECT ANSWER/i)
    end

    it "選ばなかった正解の選択肢に「CORRECT ANSWER」が表示されること" do
      target_row = page.find("li", text: /CORRECT ANSWER/i)

      expect(target_row).not_to have_content(/YOUR CHOICE/i)
    end
  end
end
