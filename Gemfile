# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.7"

gem "rails", "~> 8.1.1"

# Database & Server
gem "sqlite3", ">= 1.4"
gem "puma", ">= 5.0"

# Assets & Frontend
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails", "~> 1.4"
gem "inline_svg"

# API & Utilities
gem "jbuilder"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# Auth & Security
gem "omniauth", "~> 2.1.4"
gem "omniauth-github"
gem "omniauth-rails_csrf_protection"

# i18n & SEO
gem "rails-i18n"
gem "meta-tags", "~> 2.22"

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
end
