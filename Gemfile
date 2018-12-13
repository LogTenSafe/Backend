source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# FRAMEWORK
gem 'bootsnap'
gem 'configoro'
gem 'rails', '5.2.2'

# CONTROLLERS
gem 'responders'

# MODELS
gem 'pg', '< 1.0'

# ASSETS
gem 'coffee-rails'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'sass-rails'
gem 'sprockets-rails'
gem 'turbolinks'
gem 'uglifier'

# VIEWS
gem 'jbuilder'
gem 'nokogiri'
gem 'slim-rails'

# JOBS
gem 'sidekiq'

# IMPORTING
gem 'sqlite3'

# CRON
gem 'whenever'

# OTHER
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  gem 'listen'
  gem 'puma'

  # ERRORS
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :doc do
  gem 'redcarpet', require: 'false'
  gem 'yard', require: false
end

group :test do
  # SPECS
  gem 'rails-controller-testing'
  gem 'rspec-its', require: 'rspec/its'
  gem 'rspec-rails'

  # FACTORIES/DB
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'ffaker'
end

group :production do
  # PAPERCLIP
  gem 'aws-sdk-s3'

  # CACHING
  gem 'redis'
end
