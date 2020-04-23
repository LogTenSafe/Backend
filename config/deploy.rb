set :application, "LogTenSafe"
set :repo_url, "https://github.com/LogTenSafe/website.git"

set :deploy_to, "/var/www/logtensafe"

append :linked_files, "config/database.yml", 'config/master.key', 'config/sidekiq.yml'

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets"

set :rvm_ruby_version, "2.7.1@#{fetch :application}"

set :sidekiq_config, 'config/sidekiq.yml'

set :default_env,
    'PATH' => '/usr/local/nvm/versions/node/v12.16.2/bin:$PATH'

set :bugsnag_api_key, Rails.application.credentials.bugsnag_api_key

set :passenger_restart_with_sudo, true
