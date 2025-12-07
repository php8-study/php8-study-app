# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless, screen_size: [1400, 1400] do |options|
      options.add_argument("disable-dev-shm-usage")
      options.add_argument('disable-gpu')
    end
  end
end
