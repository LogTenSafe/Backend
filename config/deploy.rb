require File.expand_path('./environment', __dir__)

# config valid only for current version of Capistrano
lock '~> 3'

set :application, 'logtensafe'
set :repo_url, 'https://github.com/LogTenSafe/website.git'

set :deploy_to, '/var/www/www.logtensafe.com'
set :rvm_ruby_version, "2.6.4@#{fetch :application}"

append :linked_files, 'config/master.key', 'config/sidekiq.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
       'public/system'

set :bugsnag_api_key, Rails.application.credentials.bugsnag_api_key

set :default_env,
    'PATH' => '/usr/local/nvm/versions/node/v11.11.0/bin:$PATH'

set :passenger_restart_with_sudo, true
