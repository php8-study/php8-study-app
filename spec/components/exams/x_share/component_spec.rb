# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exams::XShare::Component, type: :component do
  let(:exam) { create(:exam, :with_score, correct_count: 9, question_count: 10) } # 90%

  it "正しいURLとテキストでシェアボタンが表示されること" do
    render_inline(described_class.new(exam: exam))

    expect(page).to have_link("Xで結果をシェアする")

    link = page.find_link("Xで結果をシェアする")
    href = link[:href]

    expect(href).to include("https://twitter.com/intent/tweet")
    expected_text = [
      "PHP8技術者認定初級試験の模擬試験で#{exam.score_percentage}点を取りました！",
      "Result: 🈴 PASSED! 🎉",
      "http://test.host",
      "#PHP8技術者認定初級試験 #PHP8Study #PHP"
    ].join("\n")

    expect(href).to include("text=" + CGI.escape(expected_text))
    expect(href).not_to include("hashtags=")
    expect(href).not_to include("url=")
  end

  context "試験に不合格の場合" do
    let(:exam) { create(:exam, :with_score, correct_count: 3, question_count: 10) } # 30%

    it "テキストにFAILED...が含まれていること" do
      render_inline(described_class.new(exam: exam))

      link = page.find_link("Xで結果をシェアする")
      href = link[:href]

      expect(href).to include(CGI.escape("Result: 😢 FAILED..."))
    end
  end
end
