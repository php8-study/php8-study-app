# frozen_string_literal: true

require "capybara/rspec"
require "selenium-webdriver"

Capybara.register_driver :chrome_headless_custom do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120
  client.open_timeout = 120

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    http_client: client
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :chrome_headless_custom
  end
end

Capybara.default_max_wait_time = 10
