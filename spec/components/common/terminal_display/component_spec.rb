# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::TerminalDisplay::Component, type: :component do
  let(:code) { "<?php echo 'Hello World'; ?>" }
  let(:markdown_body) { "```php\n#{code}\n```" }

  it "コードがシンタックスハイライトされて表示されること" do
    render_inline(described_class.new(body: markdown_body))

    expect(page).to have_css "pre.highlight"

    expect(page).to have_text "echo"
  end

  context "ラベルの表示" do
    it "デフォルトのラベル(Question.php)が表示されること" do
      render_inline(described_class.new(body: markdown_body))

      expect(page).to have_text "Question.php"
    end

    it "指定したラベルが表示されること" do
      render_inline(described_class.new(body: markdown_body, label: "Custom.php"))

      expect(page).to have_text "Custom.php"
    end
  end
end
