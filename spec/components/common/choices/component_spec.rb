# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Choices::Component, type: :component do
  let(:question) { create(:question) }
  let!(:choice1) { create(:question_choice, question: question, content: "選択肢1") }
  let!(:choice2) { create(:question_choice, question: question, content: "選択肢2") }

  it "選択肢が表示されること" do
    render_inline(described_class.new(question: question, input_name: "answers[]"))

    expect(page).to have_content("選択肢1")
    expect(page).to have_content("選択肢2")
    expect(page).to have_selector('input[name="answers[]"]', count: 2)
  end

  it "指定された選択肢がチェックされていること" do
    render_inline(described_class.new(
      question: question,
      input_name: "answers[]",
      selected_choice_ids: [choice1.id]
    ))

    expect(page).to have_checked_field("choice_#{choice1.id}")
    expect(page).to have_unchecked_field("choice_#{choice2.id}")
  end

  it "disabledの場合、入力が無効化されること" do
    render_inline(described_class.new(
      question: question,
      input_name: "answers[]",
      disabled: true
    ))

    expect(page).to have_selector("input[disabled]", count: 2)
  end
end
