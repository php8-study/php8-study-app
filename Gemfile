# frozen_string_literal: true

source "https://rubygems.org"
ruby "3.4.7"
gem "rails", "~> 8.1.1"
gem "sqlite3"
gem "puma"
gem "thruster"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "view_component"
gem "inline_svg"
gem "jbuilder"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]
gem "omniauth"
gem "omniauth-github"
gem "omniauth-rails_csrf_protection"
gem "rails-i18n"
gem "meta-tags"
gem "sitemap_generator"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rails_config", require: false
  gem "erb_lint", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'simplecov', require: false
end
