# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.0'

# Rails framework
gem 'rails', '~> 7.1'

gem 'http'

gem "pg"

gem "sentry-ruby"
gem "sentry-rails"

# HTTP клиент для парсинга
gem 'httparty', '~> 0.21'

# Парсинг HTML
gem 'nokogiri', '~> 1.15'

# JSON парсинг
gem 'oj', '~> 3.16'

# Фоновые задачи
gem 'sidekiq', '~> 7.2'

# Redis для Sidekiq
gem 'redis', '~> 5.0'

# Переменные окружения
gem 'dotenv-rails', '~> 2.8'

gem "playwright-ruby-client"
gem 'selenium-webdriver', '~> 4.39'
# gem "webdrivers" # подтягивает chromedriver под установленный Chrome

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 6.1'
end

group :development do
  gem 'rubocop', '~> 1.59', require: false
  gem 'rubocop-rails', '~> 2.23', require: false
end
