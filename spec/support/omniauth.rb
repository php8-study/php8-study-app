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
    visit root_path
    click_button "GitHubでログイン"
    expect(page).to have_content "LOGGED IN"
  end
end

RSpec.configure do |config|
  config.include OmniAuthHelpers, type: :system
end
