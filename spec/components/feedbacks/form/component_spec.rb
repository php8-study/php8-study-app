# frozen_string_literal: true

require "rails_helper"

RSpec.describe Feedbacks::Form::Component, type: :component do
  let(:title) { "問題を報告する" }
  let(:question_id) { 123 }

  it "ボタンテキストが正しく表示されること" do
    render_inline(described_class.new(title: title))
    expect(page).to have_button(title)
  end

  it "question_idが渡された時、フォームのhiddenフィールドに正しく含まれること" do
    render_inline(described_class.new(title: title, question_id: question_id))

    expect(page).to have_field("question_id", type: "hidden", with: question_id.to_s)

    expect(page).to have_selector("form[action*='#{new_feedback_path}']")
  end

  it "Turbo Stream形式のリクエストを送る設定になっていること" do
    render_inline(described_class.new(title: title))
    expect(page).to have_selector("form[data-turbo-stream='true']")
  end
end
