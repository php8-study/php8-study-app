# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exam Result (試験結果)", type: :system do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe "合格時の表示（100点）" do
    let!(:exam) { create(:exam, :passed, user: user) }

    let(:first_exam_question) { exam.exam_questions.first }
    let(:first_question) { first_exam_question.question }
    let(:correct_choice) { first_question.question_choices.find_by(correct: true) }

    before do
      click_link "今までの模擬試験を振り返る"
      expect(page).to have_content "模擬試験の履歴"
    end

    context "結果画面の表示" do
      before do
        find("#exam#{exam.id}").click
        expect(page).to have_content "試験結果"
      end

      it "スコアや正答数が正しく表示されている" do
        expect(page).to have_content "100"
        expect(page).to have_content "1/1"
      end

      it "回答詳細リストに問題文が表示されている" do
        within "section[aria-labelledby='detail-heading']" do
          expect(page).to have_content "回答詳細"
          expect(page).to have_content first_question.content.truncate(100)
        end
      end
    end

    context "回答詳細モーダル" do
      before do
        find("#exam#{exam.id}").click
        expect(page).to have_content "試験結果"
      end

      it "モーダルを開くと、自分の回答が「正解」として扱われている" do
        find("a[href='#{exam_exam_question_answer_path(exam, first_exam_question)}']").click

        expect(page).to have_selector "div[role='dialog']"

        within "div[role='dialog']" do
          expect(page).to have_content "正解の解説"

          correct_li = find("li", text: correct_choice.content)
          expect(correct_li).to have_content "CORRECT ANSWER"
          expect(correct_li).to have_content "YOUR CHOICE"
        end

        find("button", text: "閉じる").click
        expect(page).not_to have_selector "div[role='dialog']"
      end
    end
  end

  describe "不合格・不正解時の表示（0点）" do
    let!(:failed_exam) { create(:exam, :failed, user: user) }

    let(:failed_exam_question) { failed_exam.exam_questions.first }
    let(:question) { failed_exam_question.question }
    let(:correct_choice) { question.question_choices.find_by(correct: true) }
    let(:wrong_choice) { failed_exam_question.user_choices.first }

    before do
      click_link "今までの模擬試験を振り返る"
      expect(page).to have_content "模擬試験の履歴"
      find("#exam#{failed_exam.id}").click
      expect(page).to have_content "試験結果"
    end

    it "スコアが0点と表示されている" do
      expect(page).to have_content "0"
    end

    it "モーダルを開くと、自分の回答と正解が区別して表示されている" do
      find("a[href='#{exam_exam_question_answer_path(failed_exam, failed_exam_question)}']").click

      within "div[role='dialog']" do
        expect(page).to have_content "不正解の解説"

        user_choice_li = find("li", text: wrong_choice.content)
        expect(user_choice_li).to have_content "YOUR CHOICE"
        expect(user_choice_li).not_to have_content "CORRECT ANSWER"

        correct_li = find("li", text: correct_choice.content)
        expect(correct_li).to have_content "CORRECT ANSWER"
        expect(correct_li).not_to have_content "YOUR CHOICE"
      end
    end
  end
end
