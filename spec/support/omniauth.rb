# frozen_string_literal: true

OmniAuth.config.test_mode = true

module OmniAuthHelpers
  def mock_github_auth(user = nil)
    uid = user&.github_id || "123456"
    nickname = "test_user"
    image = "http://example.com/dummy.jpg"

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: "github",
      uid: uid,
      info: {
        nickname: nickname,
        image: image
      },
      credentials: {
        token: "mock_token"
      }
    })
  end

  def sign_in_as(user)
    mock_github_auth(user)

    if RSpec.current_example.metadata[:type] == :system
      visit root_path
      click_button "GitHubでログイン"
      expect(page).to have_content "LOGGED IN"
    else
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      get "/auth/github/callback"
    end
  end

  def sign_out
    if RSpec.current_example.metadata[:type] == :system
      click_link "ログアウト"
      expect(page).to have_content "GitHubでログイン"
    else
      delete session_path
    end
  end

  RSpec.configure do |config|
    config.include OmniAuthHelpers, type: :system
    config.include OmniAuthHelpers, type: :request
  end
end
