source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "aws-ses"
gem "bootstrap-sass"
gem "carrierwave"
gem "coffee-rails", "~> 4.2"
gem "devise"
gem "enumerize"
gem "enumerize"
gem "fog"
gem "google-analytics-rails"
gem "font-awesome-rails"
gem "hamlit-rails"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "kaminari"
gem "kaminari-i18n"
gem "lodash-rails"
gem "mini_magick"
gem "mysql2"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.2"
gem "rails-i18n"
gem "ransack"
gem "redis"
gem "redis-objects"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "unicorn"
gem "unicorn-worker-killer"
gem "whenever", require: false

group :development, :test do
  gem "factory_girl_rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "rspec-rails"
end

group :development do
  gem "annotate", require: false
  gem "capistrano"
  gem "capistrano-bundler"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
  gem "capistrano3-unicorn"
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

group :production do
  gem "dotenv-rails"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
