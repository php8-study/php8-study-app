# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Tooltip::Component, type: :component do
  before do
    render_inline(described_class.new)
  end

  it "トリガーボタンが表示され、適切な属性を持っていること" do
    trigger_wrapper = page.find("div[data-tooltip-target='trigger']")

    expect(trigger_wrapper[:class]).to include("cursor-help")

    within(trigger_wrapper) do
      button = find("button")
      expect(button).to be_present

      expect(button["aria-label"]).to eq "詳細情報"
    end
  end

  it "ツールチップ本体が表示され（DOMに存在し）、Stimulusのターゲット設定があること" do
    content = page.find("div[data-tooltip-target='content']", visible: false)

    expect(content).to be_present
    expect(content["role"]).to eq "tooltip"

    expect(content[:class]).to include("opacity-0", "invisible")
    expect(content[:class]).to include("w-96", "min-w-[320px]")
  end

  it "Stimulusコントローラーが設定されていること" do
    expect(page).to have_selector("[data-controller='tooltip']")
  end
end
