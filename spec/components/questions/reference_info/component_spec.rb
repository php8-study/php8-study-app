# frozen_string_literal: true

require "rails_helper"

RSpec.describe Questions::ReferenceInfo::Component, type: :component do
  context "参照ページが存在する場合" do
    let(:question) { create(:question, official_page: 123) }

    it "ページ数とツールチップが表示されること" do
      render_inline(described_class.new(question: question))

      expect(page).to have_content("PAGE")
      expect(page).to have_content("123")

      expect(page).to have_selector('[data-tooltip-target="trigger"]')
    end
  end

  context "参照ページが存在しない場合" do
    let(:question) { create(:question, official_page: nil) }

    it "設定されていない旨のメッセージが表示されること" do
      render_inline(described_class.new(question: question))

      expect(page).to have_content("この問題には参照情報が設定されていません")
      expect(page).not_to have_content("PAGE")
    end
  end
end
