# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Tooltip::Component, type: :component do
  before do
    render_inline(described_class.new)
  end

  it "トリガーボタンが表示され、適切な属性を持っていること" do
    button = page.find("button[data-tooltip-target='trigger']")

    expect(button).to be_present
    expect(button[:class]).to include("cursor-help")
    expect(button["aria-label"]).to eq "公式テキスト参照箇所"
  end

  it "ツールチップ本体が表示され（DOMに存在し）、Stimulusのターゲット設定があること" do
    content = page.find("div[data-tooltip-target='content']", visible: false)

    expect(content).to be_present
    expect(content["role"]).to eq "tooltip"
    expect(content[:class]).to include("opacity-0", "invisible", "fixed")
  end

  it "Stimulusコントローラーが設定されていること" do
    expect(page).to have_selector("[data-controller='tooltip']")
  end
end
