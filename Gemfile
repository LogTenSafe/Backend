source 'https://rubygems.org'

# FRAMEWORK
gem 'rails', '5.0.0.1'
gem 'configoro'
gem 'responders'

# MODELS
gem 'pg'
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

# IMPORTING
gem 'sqlite3'

# CRON
gem 'whenever'

# OTHER
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development do
  gem 'puma'

  # CHANGE WATCHING
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'

  # DEPLOYMENT
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'

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
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :production do
  gem 'aws-sdk', '>= 2.0.34'
end
