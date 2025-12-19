# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Footer::Component, type: :component do
  context "通常表示の場合（デフォルト）" do
    before do
      render_inline(described_class.new)
    end

    it "コピーライトと現在の年が表示されること" do
      expect(page).to have_content("All rights reserved.")
      expect(page).to have_content(Time.current.year.to_s)
    end

    it "必要なリンクが正しく表示されること" do
      expect(page).to have_link("利用規約", href: terms_path)
      expect(page).to have_link("プライバシーポリシー", href: privacy_path)
      expect(page).to have_link("GitHub")
    end
  end

  context "非表示フラグ(hide: true)が渡された場合" do
    before do
      render_inline(described_class.new(hide: true))
    end

    it "何も描画されないこと" do
      expect(page.text).to be_empty
    end
  end
end
