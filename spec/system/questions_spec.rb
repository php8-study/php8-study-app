# spec/system/random_questions_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ランダム出題", type: :system do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_choices) }

  before do
    sign_in_as(user)
  end

  describe "解答後のUI表示" do
    def answer_question(question, correct:)
      target_choice = question.question_choices.find_by(correct: correct)
      check target_choice.content
      expect(page).to have_checked_field(target_choice.content)
    end

    context "正解の場合" do
      before do
        visit question_path(question)
        answer_question(question, correct: true)
        click_button "解答する"
        expect(page).to have_current_path(%r{/questions/\d+/solution}, ignore_query: true)
      end

      it "正解メッセージが表示される" do
        expect(page).to have_content("正解！")
      end

      it "選んだ選択肢に正解用のクラスが適用される" do
        selected_choice = find(".relative.border-2", text: "YOUR CHOICE")
        expect(selected_choice[:class]).to include("bg-emerald-50")
        expect(selected_choice[:class]).to include("border-emerald-500")
      end
    end

    context "不正解の場合" do
      before do
        visit question_path(question)
        answer_question(question, correct: false)
        click_button "解答する"
        expect(page).to have_current_path(%r{/questions/\d+/solution}, ignore_query: true)
      end

      it "不正解メッセージが表示される" do
        expect(page).to have_content("不正解...")
      end

      it "選んだ選択肢に不正解用のクラスが適用される" do
        selected_box = find(".relative.border-2", text: "YOUR CHOICE")
        expect(selected_box[:class]).to include("bg-red-50")
        expect(selected_box[:class]).to include("border-red-400")
        expect(selected_box[:class]).to include("border-dashed")
      end

      it "正解の選択肢に正解用のクラスが適用される" do
        correct_box = find(".relative.border-2", text: "CORRECT ANSWER")
        expect(correct_box[:class]).to include("bg-emerald-50")
        expect(correct_box[:class]).to include("border-emerald-500")
      end
    end
  end
end
