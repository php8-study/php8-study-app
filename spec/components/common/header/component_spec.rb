# frozen_string_literal: true

require "rails_helper"

RSpec.describe Common::Header::Component, type: :component do
  include Rails.application.routes.url_helpers

  let(:user) { create(:user) }
  let(:github_info) { { "nickname" => "TestUser", "image" => "http://example.com/avatar.jpg" } }

  context "ログインしている場合" do
    before do
      render_inline(described_class.new(current_user: user, github_info: github_info))
    end

    it "ユーザー名が表示されること" do
      expect(page).to have_content("TestUser")
      expect(page).to have_content("Logged in")
    end

    it "アバター画像が表示されること" do
      expect(page).to have_css("img[src='http://example.com/avatar.jpg']")
    end

    it "ログアウトボタンが表示され、ログインボタンは表示されないこと" do
      expect(page).to have_link(href: session_path)
      expect(page).to have_no_content("GitHubでログイン")
    end
  end

  context "ログインしていない場合" do
    before do
      render_inline(described_class.new(current_user: nil, github_info: nil))
    end

    it "ログインボタンが表示されること" do
      expect(page).to have_button("GitHubでログイン")
    end

    it "ユーザー情報は表示されないこと" do
      expect(page).to have_no_content("Logged in")
      expect(page).to have_no_css("img[alt*='アバター']")
    end
  end

  context "非表示フラグ(hide: true)が渡された場合" do
    before do
      render_inline(described_class.new(
        current_user: user,
        github_info: github_info,
        hide: true
      ))
    end

    it "有効なデータがあっても、何も描画されないこと" do
      expect(page.text).to be_empty
    end
  end
end
