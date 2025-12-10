# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exam::History (履歴一覧)", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in_as(user)
  end

  context "履歴がない場合" do
    before do
      visit exams_path
    end

    it "「まだ履歴がありません」が表示され、受験ボタンのみ配置されている" do
      expect(page).to have_content "まだ履歴がありません"
      expect(page).to have_link "模擬試験を受ける", href: check_exams_path
    end
  end

  context "履歴がある場合" do
    let!(:exam_failed) { create(:exam, :failed, user: user, created_at: 3.days.ago) }
    let!(:exam_passed) { create(:exam, :passed, user: user, created_at: 1.day.ago) }

    before do
      visit exams_path
    end

    it "履歴が降順で表示され、各カードの内容が正しいこと", :aggregate_failures do
      expect(page).to have_link "ダッシュボードへ", href: root_path
      expect(page).to have_link "新しい模擬試験を受ける", href: check_exams_path

      cards = exam_history_cards

      expect(cards[0][:href]).to include(exam_path(exam_passed))
      expect(cards[1][:href]).to include(exam_path(exam_failed))

      verify_exam_card(exam_passed, score: "100.0%", status: "PASSED", correct_fraction: /1\s*\/\s*1/)
      verify_exam_card(exam_failed, score: "0.0%", status: "FAILED", correct_fraction: /0\s*\/\s*1/)

      click_link href: exam_path(exam_passed)
      expect(page).to have_current_path(exam_path(exam_passed))
    end
  end

  private
    def exam_history_cards
      all("a[href^='/exams/']").select do |link|
        link[:href].match?(%r{/exams/\d+$})
      end
    end

    def verify_exam_card(exam, score:, status:, correct_fraction:)
      within "a[href='#{exam_path(exam)}']" do
        expect(page).to have_content exam.created_at.strftime("%b").upcase
        expect(page).to have_content exam.created_at.day.to_s

        expect(page).to have_content "SCORE"
        expect(page).to have_content score
        expect(page).to have_content status
        expect(page).to have_content "CORRECT"
        expect(page).to have_content correct_fraction
      end
    end
end
