# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::AnswerForm::Component, type: :component do
  let(:question) { create(:question) }

  it "フォームが正しくレンダリングされること" do
    render_inline(described_class.new(
      question: question,
      url: "/test/url",
      button_text: "解答する"
    ))

    expect(page).to have_selector('form[action="/test/url"]')

    expect(page).to have_button "解答する"

    expect(page).to have_selector('[data-controller="answer-guard"]')
  end
end
