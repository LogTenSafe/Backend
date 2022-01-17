source 'https://rubygems.org'

ruby '3.1.0'

# FRAMEWORK
gem 'rack-cors'
gem 'rails'
gem 'redis'

# MODELS
gem 'active_storage_validations'
gem 'pg'

# CONTROLLERS
gem 'responders'

# AUTH
gem 'devise'
gem 'devise-jwt'

# VIEWS
gem 'jbuilder'

# ERRORS
gem 'bugsnag'

# IMPORTING
gem 'sqlite3'

# CRON
gem 'whenever'

# JOBS
gem 'sidekiq'

group :development do
  gem 'listen'
  gem 'puma'

  # DEVELOPMENT
  gem 'better_errors'
  gem 'binding_of_caller'

  # DEPLOYMENT
  gem 'bugsnag-capistrano', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-nvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
end

group :test do
  # SPECS
  gem 'rails-controller-testing'
  gem 'rspec-rails'

  # ISOLATION
  gem 'database_cleaner'
  gem 'fakefs', require: 'fakefs/safe'
  gem 'timecop'
  gem 'webmock'

  # FACTORIES
  gem 'factory_bot_rails'
  gem 'ffaker'

  # ASSERTIONS
  gem 'json_expressions', require: 'json_expressions/rspec'
end

group :production do
  # ACTIVE STORAGE
  gem 'aws-sdk-s3', require: false
end

group :doc do
  gem 'redcarpet', require: nil
  gem 'yard', require: nil
end
