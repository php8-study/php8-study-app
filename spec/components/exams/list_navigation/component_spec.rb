# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::ListNavigation::Component, type: :component do
  before do
    render_inline(described_class.new)
  end

  it "ダッシュボードへのボタンが表示され、正しいリンクが設定されていること" do
    expect(page).to have_css("a[href='#{root_path}']")
  end

  it "新規試験作成へのボタンが表示され、正しいリンクが設定されていること" do
    expect(page).to have_css("a[href='#{new_exam_path}']")
  end
end
