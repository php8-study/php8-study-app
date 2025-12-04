# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Authentication", type: :system do
  before do
    OmniAuth.config.mock_auth[:github] = nil
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  context "未ログインの場合" do
    it "トップページからGitHub認証でログインできること" do
      visit root_path
      expect(page).to have_content("PHP8技術者認定初級試験スタディ")

      mock_github_auth
      click_button "GitHubでログイン"

      expect(page).to have_link("ログアウト")
      expect(page).to have_content("test_user")
      expect(page).to have_selector("img[src='http://example.com/dummy.jpg']")
    end
  end

  context "ログイン済みの場合" do
    let(:user) { create(:user) }

    before do
      mock_github_auth(user)
      visit root_path
      click_button "GitHubでログイン"
    end

    it "ログアウトできること" do
      click_link "ログアウト"

      expect(page).to have_button("GitHubでログイン")
      expect(page).not_to have_link("ログアウト")
    end
  end
end
