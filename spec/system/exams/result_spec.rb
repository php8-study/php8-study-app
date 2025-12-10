# frozen_string_literal: true

require "rails_helper"

RSpec.describe "試験結果詳細", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in_as(user)
  end

  describe "試験結果の表示" do
    context "合格した場合" do
      let!(:exam) { create(:exam, :passed, user: user) }

      before { visit exam_path(exam) }

      it "合格のUIと共通要素が正しく表示されること" do
        expect(page).to have_content "PASSED!"
        expect(page).to have_content "おめでとうございます！"
        verify_common_result_ui(exam)
      end

      it "回答詳細リストの内容が正しいこと" do
        verify_answer_list_content(exam)
      end
    end

    context "不合格の場合" do
      let!(:exam) { create(:exam, :failed, user: user) }

      before { visit exam_path(exam) }

      it "不合格のUIと共通要素が正しく表示されること" do
        expect(page).to have_content "FAILED"
        expect(page).to have_content "残念ながら不合格です。"
        verify_common_result_ui(exam)
      end

      it "回答詳細リストの内容が正しいこと" do
        verify_answer_list_content(exam)
      end
    end
  end

  describe "詳細解説（モーダル）の確認" do
    context "正解した問題の場合" do
      let!(:exam) { create(:exam, :passed, user: user) }
      let(:question) { exam.questions.first }
      let(:text_correct) { question.question_choices.find_by(correct: true).content }

      before { visit exam_path(exam) }

      it "モーダルが開き、正解用のUIとバッジが表示される" do
        first("a[href*='solution']").click

        within "[data-controller='modal']" do
          verify_modal_common_content(question)

          expect(page).to have_content "正解の解説"
          expect(page).to have_css ".bg-emerald-100"

          verify_choice_badges(text_correct, your_choice: true, correct_answer: true)

          click_button "閉じる"
        end
        expect(page).to have_no_selector "[data-controller='modal']"
      end
    end

    context "不正解だった問題の場合" do
      let!(:exam) { create(:exam, :failed, user: user) }
      let(:question) { exam.questions.first }

      let(:text_wrong) do
        exam.exam_questions.first.user_choices.first.content
      end

      before { visit exam_path(exam) }

      it "モーダルが開き、不正解用のUIとバッジが表示される" do
        first("a[href*='solution']").click

        within "[data-controller='modal']" do
          verify_modal_common_content(question)

          expect(page).to have_content "不正解の解説"
          expect(page).to have_css ".bg-red-100"

          verify_choice_badges(text_wrong, your_choice: true, correct_answer: false)

          click_button "閉じる"
        end
        expect(page).to have_no_selector "[data-controller='modal']"
      end
    end
  end

  def verify_common_result_ui(exam)
    expect(page).to have_link "履歴一覧へ", href: exams_path, count: 2
    expect(page).to have_link "トップへ戻る", href: root_path, count: 2
    expect(page).to have_content "SCORE"
    expect(page).to have_content(/#{exam.score_percentage}\s*%/)
    expect(page).to have_content "CORRECT"
    expect(page).to have_content(/#{exam.correct_count}\s*\/\s*#{exam.total_questions}/)
    expect(page).to have_content "REQUIRED"
    expect(page).to have_content "70.0%"
  end

  def verify_answer_list_content(exam)
    within ".space-y-4" do
      target_eq = exam.exam_questions.order(:position).first
      target_question = target_eq.question
      row = first("a.group")

      within row do
        expected_bg = target_eq.correct? ? ".bg-emerald-100" : ".bg-red-100"
        unexpected_bg = target_eq.correct? ? ".bg-red-100" : ".bg-emerald-100"

        expect(page).to have_css expected_bg
        expect(page).to have_no_css unexpected_bg

        expect(page).to have_content "Q.#{target_eq.position}"
        expect(page).to have_content target_question.category.name if target_question.category
        expect(page).to have_content target_question.content
        expect(page).to have_css "svg.w-4.h-4"
      end
    end
  end

  def verify_modal_common_content(question)
    expect(page).to have_content question.category.name if question.category
    expect(page).to have_content "QUESTION"
    expect(page).to have_content "Question.php"
    expect(page).to have_content question.content
    expect(page).to have_content "選択肢の正誤"
    question.question_choices.each do |choice|
      expect(page).to have_content choice.content
    end
    expect(page).to have_content "REFERENCE"
    expect(page).to have_content question.official_page.to_s if question.official_page
    expect(page).to have_content "PAGE"
  end

  def verify_choice_badges(choice_text, your_choice:, correct_answer:)
    border_class = if correct_answer
      "border-emerald-500"
    elsif your_choice
      "border-red-400"
    else
      "border-slate-200"
    end

    target_selector = "div.border-2.#{border_class}"

    within target_selector, text: choice_text do
      if your_choice
        expect(page).to have_content "YOUR CHOICE"
      else
        expect(page).to have_no_content "YOUR CHOICE"
      end

      if correct_answer
        expect(page).to have_content "CORRECT ANSWER"
      else
        expect(page).to have_no_content "CORRECT ANSWER"
      end
    end
  end
end
