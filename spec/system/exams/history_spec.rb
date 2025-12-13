# frozen_string_literal: true

require "rails_helper"

RSpec.describe "模擬試験受験履歴一覧", type: :system do
  let(:user) { create(:user) }
  let!(:exam_passed) { create(:exam, :passed, user: user) }

  before do
    sign_in_as(user)
    visit exams_path
  end

  it "履歴カードをクリックすると詳細ページへ遷移できる" do
    click_link href: exam_path(exam_passed)
    expect(page).to have_current_path(exam_path(exam_passed))
  end
end
