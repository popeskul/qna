# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'active_model_serializers', '~> 0.10'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cocoon'
gem 'decent_exposure', '~> 3.0'
gem 'devise'
gem 'doorkeeper'
gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
gem 'gon'
gem 'handlebars_assets'
gem 'jbuilder', '~> 2.7'
gem 'letter_opener'
gem 'mini_racer'
gem 'mysql2'
gem 'oj'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'pundit'
gem 'rails', '~> 6.1.4'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim-rails'
gem 'thinking-sphinx', '~> 5.3'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq'
  gem 'capistrano3-unicorn', require: false
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pundit-matchers'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rubocop', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'capybara-email'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
