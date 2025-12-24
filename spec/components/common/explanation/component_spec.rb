# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Explanation::Component, type: :component do
  let(:question) { create(:question, explanation: "テスト解説") }

  it "解説がある場合は表示されること" do
    render_inline(described_class.new(question: question))

    expect(page).to have_text "Explanation"
    expect(page).to have_text "テスト解説"
  end

  it "解説が空（nil）の場合は、何もレンダリングされないこと" do
    question.explanation = nil

    render_inline(described_class.new(question: question))

    expect(page.text).to be_empty
  end
end
