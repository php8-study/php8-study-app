# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Flash::Component, type: :component do
  context "notice (成功) メッセージの場合" do
    let(:flash_hash) { { "notice" => "保存しました" } }

    before do
      render_inline(described_class.new(flash: flash_hash))
    end

    it "Successタイトルとメッセージが表示されること" do
      expect(page).to have_content("Success")
      expect(page).to have_content("保存しました")
    end

    it "成功時のスタイル(緑系)が適用されること" do
      expect(page).to have_css(".bg-emerald-50")
      expect(page).to have_css(".text-emerald-600")
      expect(page).to have_css("[role='status']")
    end
  end

  context "alert (エラー) メッセージの場合" do
    let(:flash_hash) { { "alert" => "エラーが発生しました" } }

    before do
      render_inline(described_class.new(flash: flash_hash))
    end

    it "Errorタイトルとメッセージが表示されること" do
      expect(page).to have_content("Error")
      expect(page).to have_content("エラーが発生しました")
    end

    it "エラー時のスタイル(赤系)が適用されること" do
      expect(page).to have_css(".bg-rose-50")
      expect(page).to have_css(".text-rose-600")
      expect(page).to have_css("[role='alert']")
    end
  end

  context "メッセージがない場合" do
    it "何も描画されないこと" do
      render_inline(described_class.new(flash: {}))
      expect(page.text).to be_empty
    end
  end
end
