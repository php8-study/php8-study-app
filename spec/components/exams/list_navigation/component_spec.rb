# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::ListNavigation::Component, type: :component do
  before do
    render_inline(described_class.new)
  end

  it "ダッシュボードへのボタンが表示され、正しいリンクが設定されていること" do
    expect(page).to have_link("ダッシュボードへ", href: root_path)

    expect(page).to have_css("a.bg-white")
  end

  it "新規試験作成へのボタンが表示され、正しいリンクが設定されていること" do
    expect(page).to have_link("新しい模擬試験を受ける", href: check_exams_path)

    expect(page).to have_css("a.bg-indigo-600")
  end
end
