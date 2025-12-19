# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::TerminalDisplay::Component, type: :component do
  let(:sample_code) { "<?php echo 'Hello World'; ?>" }

  it "渡されたコンテンツが表示されること" do
    render_inline(described_class.new(content: sample_code))

    expect(page).to have_css "pre", text: sample_code
  end

  context "ラベルが指定されていない場合" do
    it "デフォルトのラベル(Question.php)が表示されること" do
      render_inline(described_class.new(content: sample_code))

      expect(page).to have_text "Question.php"
    end
  end

  context "ラベルが指定されている場合" do
    it "指定したラベルが表示されること" do
      render_inline(described_class.new(content: sample_code, label: "RandomQuestion.php"))

      expect(page).to have_text "RandomQuestion.php"
    end
  end
end
