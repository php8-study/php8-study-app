# frozen_string_literal: true

require "rails_helper"

RSpec.describe Questions::ResultStatus::Component, type: :component do
  context "正解の場合" do
    it "正解用のスタイルとメッセージが表示されること" do
      render_inline(described_class.new(is_correct: true))

      expect(page).to have_text("正解！")
      expect(page).to have_text("素晴らしい！この調子で進めましょう。")
      expect(page).to have_selector(".bg-emerald-50")
      expect(page).to have_selector(".text-emerald-800")
    end
  end

  context "不正解の場合" do
    it "不正解用のスタイルとメッセージが表示されること" do
      render_inline(described_class.new(is_correct: false))

      expect(page).to have_text("不正解...")
      expect(page).to have_text("解説を読んで復習しましょう。")
      expect(page).to have_selector(".bg-red-50")
      expect(page).to have_selector(".text-red-800")
    end
  end
end
