source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.4.9"

# Core
gem "rails", "~> 5.1.2"
gem "puma", "~> 3.12"
gem "mysql2"
gem "enumerize"
gem "sidekiq"
gem "rails-i18n"
gem "redis"
gem "redis-objects"
gem "redis-namespace"

# Frontend
gem "bootstrap-sass"
gem "coffee-rails", "~> 4.2"
gem "font-awesome-rails"
gem "hamlit-rails"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "sass-rails", "~> 5.0"
gem "toastr-rails"
gem "turbolinks", "~> 5"
gem "lodash-rails"
gem "simple_form"
gem "kaminari"
gem "kaminari-i18n"

# Image
gem "asset_sync"
gem "carrierwave"
gem "fog-aws"
gem "mini_magick"

# Authentication
gem "devise"
gem "devise_security_extension", git: "https://github.com/phatworx/devise_security_extension.git", branch: "master"
gem "omniauth"
gem "omniauth-twitter"

# SEO
gem "google-analytics-rails"
gem "meta-tags"
gem "sitemap_generator"

# Error
gem "rambulance"
gem "rollbar"

gem "ransack"
gem "uglifier", ">= 1.3.0"
gem "therubyracer"
gem "activerecord-nulldb-adapter"

group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "rspec-rails"
end

group :development do
  gem "annotate", require: false
  gem "i18n-tasks"
  gem "letter_opener"
  gem "letter_opener_web"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "onkcop", require: false
  gem "rubocop", require: false
  gem "spring"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
