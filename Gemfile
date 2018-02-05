source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# FRAMEWORK
gem 'rails', '5.1.4'
gem 'configoro'

# CONTROLLERS
gem 'responders'

# MODELS
gem 'pg', '< 1.0'
gem 'paperclip'

# ASSETS
gem 'sass-rails'
gem 'less-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'font-awesome-rails'
gem 'sprockets-rails'

# VIEWS
gem 'jbuilder'
gem 'slim-rails'
gem 'nokogiri'

# JOBS
gem 'sidekiq'

# IMPORTING
gem 'sqlite3'

# CRON
gem 'whenever'

# OTHER
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development do
  gem 'puma'
  gem 'listen'

  # DEPLOYMENT
  gem 'capistrano', require: nil
  gem 'capistrano-rvm', require: nil
  gem 'capistrano-rails', require: nil
  gem 'capistrano-bundler', require: nil
  gem 'capistrano-passenger', require: nil
  gem 'capistrano-sidekiq', require: nil

  # ERRORS
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :doc do
  gem 'yard', require: false
  gem 'redcarpet', require: 'false'
end

group :test do
  # SPECS
  gem 'rspec-rails'
  gem 'rspec-its', require: 'rspec/its'
  gem 'rails-controller-testing'

  # FACTORIES/DB
  gem 'factory_bot_rails'
  gem 'database_cleaner'
end

group :production do
  # PAPERCLIP
  gem 'aws-sdk', '~> 2.3.0'

  # CACHING
  gem 'rack-cache', require: 'rack-cache'
  gem 'redis-rails'
end
