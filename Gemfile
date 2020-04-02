source 'https://rubygems.org'

# FRAMEWORK
gem 'bootsnap'
gem 'configoro'
gem 'rails', '6.0.2.2'

# CONTROLLERS
gem 'responders'

# MODELS
gem 'pg'

# ASSETS
gem 'bootstrap'
gem 'coffee-rails'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'sass-rails'
gem 'sprockets-rails'
gem 'tether-rails'
gem 'uglifier'

# VIEWS
gem 'jbuilder'
gem 'nokogiri'
gem 'slim-rails'

# JOBS
gem 'sidekiq', '< 6'

# IMPORTING
gem 'sqlite3'

# CRON
gem 'whenever'

# OTHER
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# ERROR TRACKING
gem 'bugsnag'

group :development do
  gem 'listen'
  gem 'puma'

  # DEPLOYMENT
  gem 'bugsnag-capistrano', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false

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
  gem 'rspec-rails', '4.0.0.beta.3'

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

  # CONSOLE
  gem 'irb', require: false

  # ASSETS
  gem 'mini_racer'
end
