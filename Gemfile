source 'https://rubygems.org'

# FRAMEWORK
gem 'rails', '4.1.6'
gem 'configoro'

# MODELS
gem 'pg'
gem 'paperclip'

# ASSETS
gem 'sass-rails', '5.0.0.beta1'
gem 'less-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'font-awesome-rails'

# VIEWS
gem 'jbuilder'
gem 'slim-rails'
gem 'nokogiri'

# IMPORTING
gem 'sqlite3'

# CRON
gem 'whenever'

group :development do
  #DEPLOYMENT
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'

  # DEVELOPMENT
  gem 'spring'
end

group :doc do
  gem 'yard', require: false
  gem 'redcarpet', require: 'false'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-its', require: 'rspec/its'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :production do
  gem 'aws-sdk'
end
