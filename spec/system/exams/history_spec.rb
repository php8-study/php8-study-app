# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exam History (試験履歴一覧)", type: :system do
  let(:user) { create(:user) }

  before do 
    sign_in_as(user)
  end

  describe "一覧画面の表示" do
    context "受験履歴がない場合" do
    before { click_link "今までの模擬試験を振り返る" }

      it "「まだ履歴がありません」と表示され、試験開始ボタンが表示される" do
        expect(page).to have_content "模擬試験の履歴"
        expect(page).to have_content "まだ履歴がありません"

        expect(page).to have_link "模擬試験を受ける", href: check_exams_path
      end
    end

    context "受験履歴がある場合" do
      let!(:old_passed_exam) do
        create(:exam, :passed, user: user, created_at: 2.days.ago, completed_at: 2.days.ago)
      end

      let!(:new_failed_exam) do
        create(:exam, :failed, user: user, created_at: 1.hour.ago, completed_at: 1.hour.ago)
      end

      let!(:active_exam) do
        create(:exam, :with_questions, user: user, created_at: 10.minutes.ago, completed_at: nil)
      end

      before { click_link "今までの模擬試験を振り返る" }

      it "完了済みの試験のみが、実施日の新しい順で表示される" do
        expect(page).to have_content "模擬試験の履歴"
        expect(page).not_to have_link href: exam_path(active_exam)

        cards = page.all(:link, href: %r{/exams/\d+$})
        expect(cards.count).to eq 2

        within cards[0] do
          expect(page).to have_content "0%"
        end
        expect(cards[0][:href]).to include(exam_path(new_failed_exam))

        within cards[1] do
          expect(page).to have_content "100.0%"
        end
        expect(cards[1][:href]).to include(exam_path(old_passed_exam))
      end
    end
  end
end
